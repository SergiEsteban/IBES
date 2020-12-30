function PlotCurrentData(handles)
% Plot channel acquired
cla(handles.CommonAxes); cla(handles.ECGAxes); cla(handles.PulseAxes);
global data dataHeader SamplingRate 

time = data(:,strcmp(dataHeader,'time'));
SamplingRate = data(1, strcmp(dataHeader,'SamplingFrequency'));
if length(dataHeader) > 3
   LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG and Pulse waves']);
   handles.CommonAxes.Visible = 'off'; handles.ECGAxes.Visible = 'on'; handles.PulseAxes.Visible = 'on';
   axes(handles.ECGAxes);
   ecg = data(:,strcmp(dataHeader,'ECG'));
   pulse = data(:,strcmp(dataHeader,'Pulse'));
   plot(time(:),  (ecg(:))); grid on; ylabel('ECG meas. ');
   title(['Imported Data (SamplingFrequency: ', num2str(SamplingRate),' Hz)']);
   axes(handles.PulseAxes);
   plot(time(:),  (pulse(:))); grid on; ylabel('Pulse meas. '); xlabel('time [s]');
elseif length(dataHeader) >2
    handles.CommonAxes.Visible = 'on'; handles.ECGAxes.Visible = 'off'; handles.PulseAxes.Visible = 'off';
    axes(handles.CommonAxes);    
    if ismember('ECG',dataHeader)     
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG wave']);           
        ecg = data(:,strcmp(dataHeader,'ECG'));
        plot(time(:),  (ecg(:))); grid on; xlabel('time [s]'); ylabel('ECG meas. ');
    else
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting Pulse wave']);            
        pulse = data(:,strcmp(dataHeader,'Pulse'));
        plot(time(:),  (pulse(:))); grid on; xlabel('time [s]'); ylabel('Pulse meas. ');
    end
end  