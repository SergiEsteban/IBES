function [result, resultFile] = ExportProcessedData()
% Exporting filtered data
filter = {'*.csv;*.xlsx', 'Supported file types (*.csv, *.xlsx)'};
[file, path, idx] = uiputfile(filter, 'Export filtered data to CSV', 'Filtered data.csv');

if idx == 0, result = 0; return; end
result = 1;
if ~strcmp('.csv', file(end-3:end)), file = [file, '.csv']; end

global dataResult dataHeader


HEADER = strjoin(dataHeader,';');
% Write header to file
fid = fopen([path,file],'w');
fprintf(fid,'%s\n',HEADER);
fclose(fid);
%write data to end of file
dlmwrite([path,file], dataResult, '-append', 'delimiter',';');
resultFile = [path,file];
end