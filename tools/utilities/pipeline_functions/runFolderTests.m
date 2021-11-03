function runFolderTests(folderNames, testTypes)
% RUNFOLDERTESTS(folderName, testTypes)
% 
% Example:
%   runFolderTests('crs_controller', 'all')
%   runFolderTests('crs_controller', {'verify', 'tests'})
%
% Copyright 2021 The MathWorks, Inc.

% Fetching folder names
proj = currentProject; % Should throw an appropriate err. msg if no proj is loaded
designDir = dir(fullfile(proj.RootFolder,'Design'));
modelFolders = designDir([designDir(:).isdir]);  
modelFolders = modelFolders(~ismember({modelFolders(:).name},{'.','..'}));

% Estimating the Valid i/p args
validFolderNames = {modelFolders(:).name, 'all'};
validTestTypes = {'build', 'verify', 'tests', 'all'};

% Validation of i/p args
folderNames = validateInputArg(folderNames, 'folderNames', validFolderNames);
testTypes = validateInputArg(testTypes, 'testTypes', validTestTypes);
rootDesignFolderPath = modelFolders.folder;
for i = 1:length(folderNames)
    modelFolderPath = fullfile(rootDesignFolderPath,folderNames{i},'pipeline');
    for j = 1:length(testTypes)
        testDir =  dir(fullfile(modelFolderPath,testTypes{j}));
        testfiles = testDir(endsWith({testDir(:).name},'.m'));
        if isempty(testfiles)
            disp(['No testfiles found in this directory - ' testDir(1).folder]);
        else
            for k = 1:length(testfiles)
                disp(['Running ', testfiles(k).name]);
                run(testfiles(k).name)
                disp(['End of ', testfiles(k).name]);
            end
        end
    end
end
end

function arg = validateInputArg(arg,argName,validArgs)
    if ~iscell(arg)
        arg = {arg};
    end
    validateattributes(arg, {'cell'}, {'row','nonempty'}, argName,...
        'runFolderTests');
    cellfun(@(x) validatestring(x, validArgs, 'runFolderTests', argName),...
        arg, 'UniformOutput', false);
    if ~isempty(find(strcmpi(arg,'all'),1))
        arg = validArgs(1:end-1);
    else
        arg = unique(arg, 'stable');
    end
end