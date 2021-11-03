% Copyright 2021 The MathWorks, Inc.
tests = modelTestsAction('ModelName', 'DriverSwRequest','TestFile', 'DriverSwRequestTestManager.mldatx', ...
    'PDFReport', 'yes', 'TAPResults', 'yes', 'JUnitFormatResults', 'yes'); 
tests.runTestsAndGenerateResults();