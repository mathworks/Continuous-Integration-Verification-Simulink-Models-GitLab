% cleanUp.m does final cleanUp tasks after closing the project
% Configured to run at project shutdown.
%
% Copyright 2021 The MathWorks, Inc.

removeCodeGenFolder = false;
removeCacheFolder   = false;
removeSlprjFolder   = true;
removeRtwgenFolder  = true;
removeSldvFolder    = true;

myProject       = matlab.project.currentProject;
projectRoot     = myProject.RootFolder;
myCodeFolder    = fullfile(projectRoot, 'Code');
myCodeGenFolder = fullfile(myCodeFolder, 'codegen');
myRtwgenFolder  = fullfile(myCodeGenFolder, 'rtwgen_tlc');
mySldvFolder    = fullfile(myCodeGenFolder, 'sldv_output');
myCacheFolder   = fullfile(myCodeFolder, 'cache');
mySlprjFolder   = fullfile(myCacheFolder, 'slprj');

if isfolder(myCodeGenFolder)
    if removeCodeGenFolder
        rmdir(myCodeGenFolder, 's'); %#ok<UNRCH>
    else
        if isfolder(myRtwgenFolder) && removeRtwgenFolder
            rmdir(myRtwgenFolder, 's');
        end
        if isfolder(mySldvFolder) && removeSldvFolder
            rmdir(mySldvFolder, 's');
        end
    end
end

if isfolder(myCacheFolder)
    if removeCacheFolder
        rmdir(myCacheFolder, 's'); %#ok<UNRCH>
    elseif isfolder(mySlprjFolder) && removeSlprjFolder
        rmdir(mySlprjFolder, 's');
    end
end

Simulink.fileGenControl('reset')

pauseTime = 1.5;
clc
fprintf('Project ''%s'' has been closed.\n', myProject.Name)
pause(pauseTime)
clc

clear removeCodeGenFolder removeCacheFolder removeSlprjFolder...
    removeRtwgenFolder removeSldvFolder myProject projectRoot...
    myCodeFolder myCodeGenFolder myCacheFolder mySlprjFolder mySldvFolder...
    myRtwgenFolder pauseTime