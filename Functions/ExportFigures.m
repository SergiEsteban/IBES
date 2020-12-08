function result = ExportFigures(handles)

global dataHeader 

fontSize = 12;

if ismember('ECG', dataHeader) 
    if ismember('Pulse', dataHeader)
        % Obtain Pulse plot
        f_pulse = figure('units', 'normalized', 'outerposition',[0,0,1,1], 'Visible', 'off');
        f_pulse_ax = copyobj(handles.PulseAxes, f_pulse);
        xlabel('time [s]');
        InSet = get(f_pulse_ax, 'TightInset');
        set(f_pulse_ax, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])

        filter = {'*.png', 'Supported file types (*png)'};
        [file, path, idx] = uiputfile(filter, 'Export filtered Pulse to PNG', 'Pulse filtered.png');
        if idx == 0, result = 0; return; end
        if ~strcmp('.png', file(end-3:end)), file = [file, '.png']; end
        set(f_pulse_ax,'Fontsize',fontSize)
        saveas(f_pulse, [path,file]);
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Exported filtered data to: ', file]);
    end
     % Obtain ECG plot
    f_ecg = figure('units', 'normalized', 'outerposition',[0,0,1,1], 'Visible', 'off');
    f_ecg_ax = copyobj(handles.CommonAxes, f_ecg);
    xlabel('time [s]');
    InSet = get(f_ecg_ax, 'TightInset');
    set(f_ecg_ax, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])

    filter = {'*.png', 'Supported file types (*png)'};
    [file, path, idx] = uiputfile(filter, 'Export filtered ECG to PNG', 'ECG filtered.png');
    if idx == 0, result = 0; return; end
    if ~strcmp('.png', file(end-3:end)), file = [file, '.png']; end
    set(f_ecg_ax,'Fontsize',fontSize)
    saveas(f_ecg, [path,file]);
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Exported filtered data to: ', file]);
else
    % Obtain Pulse plot
    f_pulse = figure('units', 'normalized', 'outerposition',[0,0,1,1], 'Visible', 'off');
    f_pulse_ax = copyobj(handles.CommonAxes, f_pulse);
    xlabel('time [s]');
    InSet = get(f_pulse_ax, 'TightInset');
    set(f_pulse_ax, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])

    filter = {'*.png', 'Supported file types (*png)'};
    [file, path, idx] = uiputfile(filter, 'Export filtered Pulse to PNG', 'Pulse filtered.png');
    if idx == 0, result = 0; return; end
    if ~strcmp('.png', file(end-3:end)), file = [file, '.png']; end
    set(f_pulse_ax,'Fontsize',fontSize)
    saveas(f_pulse, [path,file]);
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Exported filtered data to: ', file]);
end
result = 1;
end

