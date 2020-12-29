function result = ExportProcessedResults(resultsFilePath)

% Results to export: 
% 1) filepath to measurements
% 2) HR via ECG array
% 2.1) HR 20 seconds average ECG
% 3) HR via Pulse array
% 3.1) HR 20 seconds average Pulse
% 4) Arrival time array
% 4.1) Arrival time average
% 5) Blood Pressure parameters
% 5.1) BloodPressure Estimate
% 6) Respiratory Rate parameters
% 6.1) Respiratory Rate Estimate
% 7) Other results (R peaks and values, i.e.)

filter = {'*.txt', 'Supported file types (*.txt)'};
[file, path, idx] = uiputfile(filter, 'Export ECG', 'ECG measurement.txt');
if idx == 0, result = 0; return; end
result = 1;
if ~strcmp('.txt', file(end-3:end)), file = [file, '.txt']; end

fid = fopen([path, file], 'w');
global dataHeader
% 1) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fid, 'Measured results are presented in this file from: %s\n\n',resultsFilePath);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ecgHeartRate ecgHeartRate20sAvg
txt = 'HeartRate (bpm):\t';
if isempty(ecgHeartRate), txt = [txt, 'N/A'];
else
    for hr = ecgHeartRate
        txt = [txt, num2str(hr*60), ', '];
    end
    txt(end-1) = ']'; txt(end) = '';
end

fprintf(fid,'\nFrom ECG measurement\n');
% 2) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fid, [txt, '\n']);
% 2.1) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt = '20sAvgHeartRate(bpm):\t';
if isempty(ecgHeartRate20sAvg), txt = [txt, 'N/A']; 
else
    txt = [txt, num2str(ecgHeartRate20sAvg*60)];
end
fprintf(fid, [txt,'\n']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global pulseHeartRate pulseHeartRate20sAvg
txt = 'HeartRate (bpm):\t';
if isempty(pulseHeartRate), txt = [txt, 'N/A'];
else
    for hr = pulseHeartRate
        txt = [txt, num2str(hr), ', '];
    end
    txt(end-1) = ']'; txt(end) = '';
end

fprintf(fid,'\nFrom PULSE measurement\n');
% 3) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fid, [txt,'\n']);
% 3.1) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt = '\t20sAvgHeartRate(bpm):\t';
if isempty(pulseHeartRate20sAvg), txt = [txt, 'N/A']; 
else
    txt = [txt, num2str(pulseHeartRate20sAvg*60)];
end
fprintf(fid, [txt,'\n']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global arrivalTime arrivalTimeAvg
txt = '\nArrivalTime (ms):\t';
if isempty(arrivalTime), txt = [txt, 'N/A'];
else
    for at = arrivalTime
        txt = [txt, num2str(at/1e-3), ', '];
    end
    txt(end-1) = ']'; txt(end) = '';
end

% 4) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(fid, [txt,'\n']);
% 4.1) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
txt = 'ArrivalTimeAvg (ms):\t';
if isempty(arrivalTimeAvg), txt = [txt, 'N/A']; 
else
    txt = [txt, num2str(arrivalTimeAvg/1e-3)];
end
fprintf(fid, [txt,'\n']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fclose(fid);

end