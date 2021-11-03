% Copyright 2021 The MathWorks, Inc.
% This script uses the generated XML file and the styles present in XSL
% file to give a final Summary Report for every model in the pipeline
function generateHTMLReport(modelName)
  load(fullfile('Code','logsPath.mat'),'path');
  parentFolder = fullfile('Design', modelName, 'pipeline', 'analyze');
  if ~exist(fullfile(parentFolder, 'package'), 'dir')
      mkdir([parentFolder, '\package']);
  end
  xslt(fullfile(path,'logs',[modelName 'Report.xml']), 'report.xsl', fullfile('Design',modelName,'pipeline','analyze', 'package', [modelName 'SummaryReport.html']));
end