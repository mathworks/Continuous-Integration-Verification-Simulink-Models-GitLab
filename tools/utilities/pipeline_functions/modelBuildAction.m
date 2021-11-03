% Copyright 2021 The MathWorks, Inc.
% This script builds a specified model.
% Example: 
% mb = modelBuildAction('TargetSpeedThrottle'); 
% mb.build();

classdef modelBuildAction
    % MODELBUILD Assists in building models and managing artifacts
    
    properties
        prj;
        cfg;
        modelName;
    end
    
    methods
        function obj = modelBuildAction(ModelName)
              if nargin == 0
                error('Please provide your model name');
              end            
            obj.modelName = ModelName;
            obj.prj = matlab.project.currentProject;
            obj.cfg = Simulink.fileGenControl('getConfig');
        end
        
        function build(obj)
            cd(obj.cfg.CodeGenFolder);

            load_system(obj.modelName)
            % Build            
            cs = getActiveConfigSet(obj.modelName);
            sysTarg = get_param(cs, 'SystemTargetFile');
            switch sysTarg
                case 'grt.tlc'
                    slbuild(obj.modelName); 
                case 'rsim.tlc'
                    slbuild(obj.modelName);
                case 'ert.tlc'
                    rtwbuild(obj.modelName);
                otherwise
                    % a log file for Summary Report in pipeline
                    load(fullfile('Code','logsPath.mat'),'path');
                    fileID = fopen(fullfile(path,'logs',[obj.modelName 'BuildLog.json']),'w');
                    s = struct('Result','Failed','Path', 'No CodeGen report generated');
                    fprintf(fileID, jsonencode(s));
                    fclose('all');
                    error("Target not supported.  Please change to 'ert' or 'grt'.")
            end
            
            %Clean up
            bdclose('all');
            cd(obj.prj.RootFolder)
            
            % placing the report under analyze folder
            srcReportPath = fullfile(obj.cfg.CodeGenFolder,[obj.modelName '_ert_rtw'], 'html');
            parentFolder = fullfile(char(obj.prj.RootFolder), 'Design', obj.modelName, 'pipeline', 'analyze');
            if ~exist(fullfile(parentFolder, 'build'), 'dir')
                mkdir([parentFolder, '\build']);
            end
            destReportPath = fullfile(char(obj.prj.RootFolder), 'Design', obj.modelName, 'pipeline', 'analyze', 'build');
            
            copyfile(srcReportPath, destReportPath);
            
            % a log file for Summary Report in pipeline
            load(fullfile('Code','logsPath.mat'),'path');
            fileID = fopen(fullfile(path,'logs',[obj.modelName 'BuildLog.json']),'w');
            s = struct('Result','Passed','Path', strrep(fullfile('..', 'build', [obj.modelName '_codegen_rpt.html']), filesep,[filesep filesep]));
            fprintf(fileID, jsonencode(s));
            fclose('all');
        end
    end
end
