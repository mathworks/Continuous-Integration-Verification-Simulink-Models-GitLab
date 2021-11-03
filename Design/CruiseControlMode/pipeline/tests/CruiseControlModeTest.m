% Copyright 2021 The MathWorks, Inc.
tests = modelTestsAction('ModelName', 'CruiseControlMode',...
    'TestFile', 'CruiseControlModeTestManager.mldatx', 'PDFReport', 'yes', 'JUnitFormatResults', 'yes'); 
tests.runTestsAndGenerateResults();