% Copyright 2021 The MathWorks, Inc.
tests = modelTestsAction('ModelName', 'TargetSpeedThrottle','TestFile', 'TargetSpeedThrottleTestManager.mldatx', ...
    'PDFReport', 'yes', 'SimulinkTestMgrResults', 'yes', 'JUnitFormatResults', 'yes'); 
tests.runTestsAndGenerateResults();