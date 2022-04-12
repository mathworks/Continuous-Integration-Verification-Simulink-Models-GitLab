% Copyright 2021 The MathWorks, Inc.

% RUNALLTESTSLOCALLY
% This file is used to run selected project items locally.
% All the different scripts which are run in the CI pipeline can be run
% locally by using this script

%% crs_controller
% verify
crs_controllerModelAdvisor

% build
crs_controllerBuild

% test
crs_controllerTestFile

%% CruiseControlMode
% verify
CruiseControlModeModelAdvisor

% build
CruiseControlModeBuild

% test
CruiseControlModeTest

%% DriverSwRequest
% verify
DriverSwRequestModelAdvisor

% build
DriverSwRequestBuild

% test
DriverSwRequestTest

%% TargetSpeedThrottle
% verify
TargetSpeedThrottleModelAdvisor

% build
TargetSpeedThrottleBuild

% test
TargetSpeedThrottleTest
