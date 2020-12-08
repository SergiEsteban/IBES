function [result, file] = ExportRawData()

filter = {'*.csv;*.xlsx', 'Supported file types (*.csv, *.xlsx)'};
[file, path, idx] = uiputfile(filter, 'Export ECG', 'ECG measurement.csv');
if idx == 0, result = 0; return; end
result = 1;
if ~strcmp('.csv', file(end-3:end)), file = [file, '.csv']; end

global data dataHeader

dataHeader = strjoin(dataHeader,';');
% Write header to file
fid = fopen([path,file],'w'); 
fprintf(fid,'%s\n',dataHeader);
fclose(fid);
%write data to end of file
dlmwrite([path,file], data, '-append', 'delimiter',';');
end

