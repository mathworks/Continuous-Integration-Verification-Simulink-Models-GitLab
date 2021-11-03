% Copyright 2021 The MathWorks, Inc.
% This script runs the test for a specified model.
% Example: modelTestsAction('ModelName', 'TargetSpeedThrottle','TestFile', 'TargetSpeedThrottleTestManager.mldatx', ...
%          'PDFReport', 'yes', 'SimulinkTestMgrResults', 'yes', 'JUnitFormatResults', 'yes'); 

classdef modelTestsAction    
    properties
        parser;
        modelName;
        testFile;
        TAPResults;
        PDFReport;
        JUnitFormatResults;
        simulinkTestMgrResults;
        modelCoverage;
        testRunner;
        suite;
        resultsPath;
        resultTable;
    end    
    
    methods (Access = public)        
        function obj = modelTestsAction(~, varargin)
            
            if nargin == 0
                error('Too few input arguments.');
            end
            
           obj = inputParserSetup(obj);
           obj = parseInput(obj, varargin{:});  
           relVer = release_version;
           relVerNum = str2double(relVer(2:5));
           if relVerNum > 2020 % Introduced in R2021a
               sltest.testmanager.setpref('ShowSimulationLogs', 'IncludeOnCommandPrompt', true)
           end
        end
        
        function obj = runTestsAndGenerateResults(obj)
            import matlab.unittest.TestSuite;
            import matlab.unittest.TestRunner;
            import matlab.unittest.plugins.*;
            import matlab.unittest.Verbosity;
            import sltest.plugins.*;
            import sltest.plugins.coverage.*;
            import matlab.unittest.plugins.codecoverage.CoverageReport;
            import sltest.plugins.coverage.ModelCoverageReport;
            import matlab.unittest.plugins.codecoverage.CoberturaFormat;
            import sltest.plugins.coverage.CoverageMetrics;
            
            % Check for required and correct arguments
            if isempty(which(obj.modelName))
                error("Provided model does not exist or is not on path");
            end
            if isempty(obj.testFile)
                error("Please provide a test file to run tests on the model");
            end
            if isempty(which(obj.testFile))
                error("Provided test file does not exist or is not on path");
            end
            
            % Move to working directory
            prj = matlab.project.currentProject;
            
            obj.suite = testsuite(obj.testFile);
            obj.testRunner = TestRunner.withNoPlugins;
            parentFolder = fullfile(char(prj.RootFolder), 'Design', obj.modelName, 'pipeline', 'analyze');
            if ~exist(fullfile(parentFolder, 'testing'), 'dir')
                mkdir([parentFolder, '\testing']);
            end
            obj.resultsPath = fullfile(char(prj.RootFolder), 'Design', obj.modelName, 'pipeline', 'analyze', 'testing');
            delete(fullfile(obj.resultsPath, '*.tap'));
            if strcmp(obj.PDFReport, 'yes')
                pdfFile = fullfile(obj.resultsPath, [obj.modelName 'TestResults.pdf']);
                trp = TestReportPlugin.producingPDF(pdfFile);
                addPlugin(obj.testRunner, trp);
            end
            
            if strcmp(obj.TAPResults, 'yes')
                tapFile = fullfile(obj.resultsPath, [obj.modelName 'TAPResults.tap']);
                tap = TAPPlugin.producingVersion13(ToFile(tapFile));
                addPlugin(obj.testRunner, tap);
            end
            
            if strcmp(obj.simulinkTestMgrResults, 'yes')
                tmr = TestManagerResultsPlugin('ExportToFile', fullfile(obj.resultsPath, [obj.modelName 'SimulinkTestMgrResults.mldatx']));
                addPlugin(obj.testRunner, tmr)
            end
            
            if strcmp(obj.JUnitFormatResults, 'yes')
                % Creating a file to write output in xml
                fid = fopen(fullfile(obj.resultsPath, [obj.modelName 'JUnitFormatTestResults.xml']), 'w');
                fclose(fid);
                
                % Create a XML plugin that produces output in xml with Verbosity:conscise
                XMLplugin = XMLPlugin.producingJUnitFormat(fullfile(obj.resultsPath, [obj.modelName 'JUnitFormatTestResults.xml']), 'OutputDetail', Verbosity.Concise);
                addPlugin(obj.testRunner, XMLplugin);
            end
            
            if strcmp(obj.modelCoverage, 'yes')
                % Model Coverage report path
                  rptFile = fullfile(obj.resultsPath, [obj.modelName 'ModelCoverage.xml']);
                  rpt = CoberturaFormat(rptFile);
                
                % Model Coverage Plugin
                covSettings = ModelCoveragePlugin('RecordModelReferenceCoverage', false, 'Producing', rpt);
                addPlugin(obj.testRunner, covSettings);
            end
            
            obj.resultTable = table(run(obj.testRunner, obj.suite));
            
            fprintf("Result Summary : \n");
            disp(obj.resultTable);
            
            % a log file for Summary Report in pipeline
            load(fullfile('Code','logsPath.mat'),'path');
            fileID = fopen(fullfile(path,'logs',[obj.modelName 'TestLog.json']),'w');
            s = struct('Passed',sum(obj.resultTable.Passed == true), 'Failed', sum(obj.resultTable.Failed == true),'PDFReport', obj.PDFReport,'TestFile',obj.testFile,'TAPResults', obj.TAPResults,'Path', strrep(fullfile('..', 'testing', [obj.modelName 'TestResults.pdf']), filesep,[filesep filesep]), 'RunnerDescription', getenv('CI_RUNNER_DESCRIPTION'), 'PipelineCreated', getenv('CI_PIPELINE_CREATED_AT'), 'ProjectURL', getenv('CI_PROJECT_URL'), 'Branch', getenv('CI_COMMIT_BRANCH'), 'Commit', getenv('CI_COMMIT_SHA'));
            fprintf(fileID, jsonencode(s));
            fclose('all');
            
            if any(obj.resultTable.Failed)
                error("Please resolve the above tests which had failed");
            end
            
            % Basic CleanUp.
            sltest.testmanager.clearResults;
            sltest.testmanager.clear;
            sltest.testmanager.close;
            
            fprintf("\n\n End %s Model test call. \n\n", obj.modelName);
            
            disp('Test Results has been generated at');
            disp(obj.resultsPath);
        end        
    end
        
    methods (Access = private)    
        function obj = inputParserSetup(obj)
            arg_name_1 = 'ModelName';
            
            arg_name_2 = 'TestFile';
            defaultTestFile = '';
                        
            arg_name_3 = 'TAPResults';
            defaultTAPResults = 'no';
            
            arg_name_4 = 'PDFReport';
            defaultPDFReport = 'no';
            
            arg_name_5 = 'JUnitFormatResults';
            defaultJUnitResults = 'no';
            
            arg_name_6 = 'SimulinkTestMgrResults';
            defaultSimulinkTestMgrResults = 'no';
            
            arg_name_7 = 'CoberturaModelCoverage';
            defaultCoberturaModelCoverage = 'no';
            
            obj.parser = inputParser;            
            addRequired(obj.parser, arg_name_1);
            addParameter(obj.parser, arg_name_2, defaultTestFile);
            addParameter(obj.parser, arg_name_3, defaultTAPResults);
            addParameter(obj.parser, arg_name_4, defaultPDFReport);
            addParameter(obj.parser, arg_name_5, defaultJUnitResults);
            addParameter(obj.parser, arg_name_6, defaultSimulinkTestMgrResults);
            addParameter(obj.parser, arg_name_7, defaultCoberturaModelCoverage); 
        end    
        
        function obj = parseInput(obj, ModelName, varargin)
            parse(obj.parser, ModelName, varargin{:});
            obj.modelName = char(obj.parser.Results.ModelName);
            obj.testFile = char(obj.parser.Results.TestFile);
            obj.TAPResults = char(obj.parser.Results.TAPResults);
            obj.PDFReport = char(obj.parser.Results.PDFReport);
            obj.JUnitFormatResults = char(obj.parser.Results.JUnitFormatResults);
            obj.simulinkTestMgrResults = char(obj.parser.Results.SimulinkTestMgrResults);
            obj.modelCoverage = char(obj.parser.Results.CoberturaModelCoverage);
        end       
    end       
end
