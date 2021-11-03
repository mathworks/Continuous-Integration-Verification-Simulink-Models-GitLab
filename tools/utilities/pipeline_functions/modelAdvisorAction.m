classdef modelAdvisorAction
    % MODELADVISORACTION performs Model Advisor checks on the model.
    % If Model Advisor configuration file is available it has to be set
    % before calling the run() method else Model Advisor will run checks
    % described in the 'checks' member variable of the class.
    % If report configuration object is available it has to be set before calling
    % the generateReport() method.
    
    % Copyright 2021 The MathWorks, Inc.
    properties
        modelName;
        prj;
        prjRootFolder;
        rptPath;
        mdlPath;
        configFile;
        rptCfg;
        checkResult;
        result;
        checks = {
            'mathworks.design.UnconnectedLinesPorts'
            'mathworks.design.UnitMismatches'
            'mathworks.design.UnresolvedLibLinks'
            'mathworks.design.ReplaceZOHDelayByRTB'
            'mathworks.design.UnitMismatches'
            'mathworks.design.AutoUnitConversions'
            'mathworks.design.DisallowedUnitSystems'
            'mathworks.design.AmbiguousUnits'
            'mathworks.design.UseSLXFile'
            'mathworks.design.CheckSavedInCurrentVersion'
            'mathworks.design.CheckSavedInCurrentVersion'
            'mathworks.design.characterEncoding'
            'mathworks.design.CaseSensitiveBlockDiagramNames'
            'mathworks.jmaab.db_0081'
            'mathworks.jmaab.jc_0201'
            'mathworks.jmaab.jc_0243'
            };
        superSystemChecks = {
            'mathworks.design.UnresolvedLibLinks'
            'mathworks.metricchecks.SubSystemCount'
            'mathworks.metricchecks.SubSystemDepth'
            };
    end
    
    methods(Access = public)
        function obj = modelAdvisorAction(modelName)
            % If no model name is supplied
            if nargin == 0
                error('Please provide a model name');
            end
            
            % If provided model name is empty
            if isempty(modelName)
                ME = MException('Model name is empty');
                throw(ME);
            end
            
            % Set some member variables of the object.
            obj.modelName = char(modelName);
            obj.prj = matlab.project.currentProject;
            obj.prjRootFolder = char(obj.prj.RootFolder);
            
            obj.mdlPath = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'specification');
            %creates specific subfolder for report
            parentFolder = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'pipeline', 'analyze');
            if ~exist(fullfile(parentFolder, 'verify'), 'dir')
                mkdir([parentFolder, '\verify']);
            end
            obj.rptPath = fullfile(obj.prjRootFolder, 'Design', obj.modelName, 'pipeline', 'analyze', 'verify');
            
            % Perform cleanup before performing model advisor checks
            obj.preChecks();
        end
        
        function obj = run(obj)
            % Check if external configFile is specified
            if isempty(obj.configFile)
                % Adjust model advisor checks depending on model reference content
                if obj.hasModelReference()
                    obj.checks = vertcat(obj.checks, obj.superSystemChecks);
                end
                obj.checkResult = ModelAdvisor.run(...
                    obj.modelName, obj.checks,...
                    'Force', 'On', 'DisplayResults', 'None');
            else
                % Run Model Advisor checks with config file
                obj.checkResult = ModelAdvisor.run(...
                    obj.modelName, 'Configuration', obj.configFile,...
                    'Force', 'Off', 'DisplayResults', 'None');
            end
        end
        
        function obj = generateReport(obj)           
            % Set name of report and path for report
            obj.rptCfg.ReportName = [obj.modelName 'ModelAdvisorReport'];
            obj.rptCfg.ReportPath = obj.rptPath;
            
            % Setup result struct to summarize results
            obj.rptCfg.ViewReport = false;
            obj.result.Method = 'run';
            obj.result.Component = obj.modelName;
            obj.result.NumTotal = 0;
            obj.result.NumPass = 0;
            obj.result.NumWarn = 0;
            obj.result.NumFail = 0;
            obj.result.Results = [];
            for i = 1:length(obj.checkResult)
                if strcmpi(obj.checkResult{i}.system, obj.modelName)
                    obj.result.NumPass = obj.checkResult{i}.numPass;
                    obj.result.NumWarn = obj.checkResult{i}.numWarn;
                    obj.result.NumFail = obj.checkResult{i}.numFail;
                    obj.result.NumTotal = obj.checkResult{i}.numNotRun + obj.result.NumFail + obj.result.NumWarn + obj.result.NumPass;
                    
                    if obj.result.NumFail > 0
                        obj.result.Outcome = -1;
                    elseif obj.result.NumWarn > 0
                        obj.result.Outcome = 0;
                    else
                        obj.result.Outcome = 1;
                    end
                    obj.result.Results = obj.checkResult{i};
                    break;
                end
            end
            
            disp('Model Advisor results: \n');
            disp(obj.result);
            
            %to place the corresponding model advisor report in analyze
            %folder
            srcReportPath = fullfile(char(obj.prjRootFolder), 'Code', 'cache', 'slprj','modeladvisor', char(obj.modelName), 'report.html');
            destReportPath = fullfile(char(obj.rptPath), [obj.modelName 'ModelAdvisorReport.html']);
            movefile(srcReportPath, destReportPath);
            
            % a log file for Summary Report in pipeline
            load(fullfile('Code','logsPath.mat'),'path');
            fileID = fopen(fullfile(path,'logs', [obj.modelName 'ModelAdvisorLog.json']),'w');
            s = struct('Passed', obj.result.NumPass,'Failed',obj.result.NumFail,'Warnings', obj.result.NumWarn,'Total', obj.result.NumTotal, 'Path', strrep(fullfile('..', 'verify', [obj.modelName 'ModelAdvisorReport.html']), filesep,[filesep filesep]));
            fprintf(fileID, jsonencode(s));
            fclose('all');
                        
            %Close any open models
            bdclose('all');
        end
    end
    
    methods(Access = private)
        function output = hasModelReference(obj)
            [~, blocks] = find_mdlrefs(obj.modelName);
            if isempty(blocks)
                output = 0;
            else
                output = 1;
            end
        end
        
        function preChecks(obj)
            bdclose('all');
            % Delete old report if it exists
            pdfFile = fullfile(obj.rptPath, [obj.modelName 'ModelAdvisorReport.pdf']);
            if exist(pdfFile, 'file')
                delete(pdfFile);
            end
            
            htmlFile = fullfile(obj.rptPath, [obj.modelName 'ModelAdvisorReport.html']);
            if exist(htmlFile, 'file')
                delete(htmlFile);
            end
            
            % Check if model exists.
            if ~isfile(fullfile(obj.mdlPath, [obj.modelName '.slx']))
                error("Model does not exist");
            end
            load_system(obj.modelName); % needed to suppress warning to remove report
        end
    end
end
