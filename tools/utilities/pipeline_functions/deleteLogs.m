% Copyright 2021 The MathWorks, Inc.
% This script deletes all the logs generated at every stage of the pipeline
load(fullfile('Code','logsPath.mat'),'path');
rmdir(fullfile(path,'logs'),'s')