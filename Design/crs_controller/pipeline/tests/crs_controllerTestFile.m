% Copyright 2021 The MathWorks, Inc.
tests = modelTestsAction('ModelName', 'crs_controller',...
    'TestFile', 'crs_controllerTestManager.mldatx', 'PDFReport', 'yes', 'JUnitFormatResults', 'yes'); 
tests.runTestsAndGenerateResults();