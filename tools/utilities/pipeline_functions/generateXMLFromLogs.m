% Copyright 2021 The MathWorks, Inc.
% This script uses the logs generated at every stage and generates a single
% XML file containing the dynamic model results data
% a html template which generates a summary report in the deploy stage
% run this file by passing model name as an input

function generateXMLFromLogs(modelName)
   %loading the path of logs: this value is set in startup.m
   load(fullfile('Code','logsPath.mat'),'path');
   %fetching all the results data
   modelAdvisorResult = jsondecode(fileread(fullfile(path,'logs',[modelName 'ModelAdvisorLog.json'])));
   buildResult = jsondecode(fileread(fullfile(path,'logs',[modelName 'BuildLog.json'])));
   testResult = jsondecode(fileread(fullfile(path,'logs',[modelName 'TestLog.json'])));
   %creating the summary report file
   fileID = fopen(fullfile(path,'logs',[modelName 'Report.xml']),'w');
   fprintf(fileID, '<?xml version="1.0" encoding="UTF-8"?>\n');
   fprintf(fileID, '<reports>\n');
   fprintf(fileID, append('<Title>',modelName,' - Report','</Title>\n'));
   % Model Advisor summary
   fprintf(fileID, '<stage>\n');
   fprintf(fileID, '<Description>ModelAdvisor</Description>\n');
   fprintf(fileID, append('<Passed>',num2str(modelAdvisorResult.Passed),'</Passed>\n'));
   fprintf(fileID, append('<Path>',strrep(modelAdvisorResult.Path,filesep,[filesep filesep]),'</Path>\n'));
   fprintf(fileID, '</stage>\n');
   % filling Build results summary
   fprintf(fileID, '<stage>\n');
   fprintf(fileID, '<Description>Build</Description>\n');
   fprintf(fileID, append('<Passed>',buildResult.Result,'</Passed>\n'));
   fprintf(fileID, append('<Path>',strrep(buildResult.Path,filesep,[filesep filesep]),'</Path>\n'));
   fprintf(fileID, '</stage>\n');
   % filling test results summary
   fprintf(fileID, '<stage>\n');
   fprintf(fileID, '<Description>Test</Description>\n');
   fprintf(fileID, append('<Passed>',num2str(testResult.Passed),'</Passed>\n'));
   fprintf(fileID, append('<Path>',strrep(testResult.Path,filesep,[filesep filesep]),'</Path>\n'));
   fprintf(fileID, '</stage>\n');

   fprintf(fileID, '<ModelAdvisor>\n');
   fprintf(fileID, append('<Passed>',num2str(modelAdvisorResult.Passed),'</Passed>\n'));
   fprintf(fileID, append('<Warnings>',num2str(modelAdvisorResult.Warnings),'</Warnings>\n'));
   fprintf(fileID, append('<Failed>',num2str(modelAdvisorResult.Failed),'</Failed>\n'));
   fprintf(fileID, append('<Total>',num2str(modelAdvisorResult.Total),'</Total>\n'));
   fprintf(fileID, '</ModelAdvisor>\n');

   fprintf(fileID, '<Test>\n');
   fprintf(fileID, append('<Passed>',num2str(testResult.Passed),'</Passed>\n'));
   fprintf(fileID, append('<Failed>',num2str(testResult.Failed),'</Failed>\n'));
   fprintf(fileID, append('<PDFReport>',testResult.PDFReport,'</PDFReport>\n'));
   fprintf(fileID, append('<TAPResults>',testResult.TAPResults,'</TAPResults>\n'));
   fprintf(fileID, append('<RunnerDescription>',testResult.RunnerDescription,'</RunnerDescription>\n'));
   fprintf(fileID, append('<PipelineCreated>',testResult.PipelineCreated,'</PipelineCreated>\n'));
   fprintf(fileID, append('<ProjectURL>',strrep(fullfile(testResult.ProjectURL,'-', 'tree', testResult.Branch), filesep, [filesep filesep]),'</ProjectURL>\n'));
   fprintf(fileID, append('<CommitID>',testResult.Commit,'</CommitID>\n'));
   fprintf(fileID, append('<Commit>',strrep(fullfile(testResult.ProjectURL,'-', 'commit', testResult.Commit), filesep, [filesep filesep]),'</Commit>\n'));
   fprintf(fileID, '</Test>\n');
   fprintf(fileID, '</reports>');
   fclose('all');
end