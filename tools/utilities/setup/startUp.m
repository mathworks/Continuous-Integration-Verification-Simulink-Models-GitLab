% startUp.m sets up the project settings
% Configured to run at project startup
%
% Copyright 2021 The MathWorks, Inc.

% Clear the workspace.
evalin('base', 'clear;');

% Close all figures.
close('all');

% Close all models.
bdclose('all');

myProject       = matlab.project.currentProject;
projectRoot     = myProject.RootFolder;
myCodeFolder    = fullfile(projectRoot, 'Code');
myCodeGenFolder = fullfile(myCodeFolder, 'codegen');
myCacheFolder   = fullfile(myCodeFolder, 'cache');


myProject.SimulinkCacheFolder   = myCacheFolder;
myProject.SimulinkCodeGenFolder = myCodeGenFolder;

Simulink.fileGenControl('set',...
    'CacheFolder', myCacheFolder,...
    'CodeGenFolder', myCodeGenFolder,...
    'createDir', true)

% a variable to indicate where to place the logs for pipeline, if this
% value is changed please ensure to change the variable in gitlab-ci.yml
% file as this variable is used to store the logs as an artifact in verify,
% build, test stages
path = './Code';
save ./Code/logsPath path;
load(fullfile('Code','logsPath.mat'),'path');
if ~exist(fullfile(path, 'logs'), 'dir')
    mkdir([path,'/logs']);
end

pauseTime = 1.5;
clc
fprintf('Opening project ''%s''...\n', myProject.Name)
pause(pauseTime)
clc

clear myProject projectRoot myCodeFolder myCodeGenFolder myCacheFolder pauseTime