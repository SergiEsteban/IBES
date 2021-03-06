
%%%%%%%%%%%%%%%%%%%%%%%%%% Initialize GUI %%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = MeasurementsGUI(varargin)
% MEASUREMENTSGUI MATLAB code for MeasurementsGUI.fig
%      MEASUREMENTSGUI, by itself, creates a new MEASUREMENTSGUI or raises the existing
%      singleton*.
%
%      H = MEASUREMENTSGUI returns the handle to a new MEASUREMENTSGUI or the handle to
%      the existing singleton*.
%
%      MEASUREMENTSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASUREMENTSGUI.M with the given input arguments.
%
%      MEASUREMENTSGUI('Property','Value',...) creates a new MEASUREMENTSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MeasurementsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MeasurementsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MeasurementsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @MeasurementsGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before MeasurementsGUI is made visible.
function MeasurementsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MeasurementsGUI (see VARARGIN)

% Choose default command line output for MeasurementsGUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes MeasurementsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%% Clear cmd windows and include all folders under the working dir. %%%
clc;
addpath(genpath(pwd));
global DEBUG_MODE
DEBUG_MODE = 0;

SetDefaultValues(handles)

LogTrace(handles, '', ['LogSession: ', datestr(now, 'dd/MM/yyyy')]);
LogTrace(handles, datestr(now,'[hh:mm:ss]'), 'ECG Measurement GUI initialized');

% --- Outputs from this function are returned to the command line.
function varargout = MeasurementsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%% Measurement Configuration %%%%%%%%%%%%%%%%%%%%%%%%

function MACaddr_Callback(hObject, eventdata, handles)
% hObject    handle to MACaddr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

content    = cellstr(get(hObject,'String')); content = strtrim(content{1});
global mac
% Check if the contained string has changed
if ~strcmp(mac,content)
    % Update MAC address (user input)
    mac = content;
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['MAC address updated to ', num2str(mac)]);
end
% --- Executes during object creation, after setting all properties.
function MACaddr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MACaddr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function SamplingFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to SamplingFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents    = cellstr(get(hObject,'String'));
Fs          = contents{get(hObject,'Value')};
global SamplingRate
% Cheack if the contained value has changed
if SamplingRate ~= str2double(Fs)
    % Update Sampling Frequency (user input)
    SamplingRate = str2double(Fs);
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['SamplingFrequency updated to ', num2str(Fs), ' Hz']);
end
% --- Executes during object creation, after setting all properties.
function SamplingFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SamplingFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in NSamplesPopUp.
function NSamplesPopUp_Callback(hObject, eventdata, handles)
% hObject    handle to NSamplesPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents    = cellstr(get(hObject,'String'));
selection   = contents{get(hObject,'Value')};
selectionIdx= find(ismember(contents, selection));
global nSamplesSelection nSamples SamplingRate
% Cheack if NSamples mode has changed
if nSamplesSelection ~= selectionIdx
    % Update displaying number according to the current mode
    if selectionIdx == 1, handles.NumberOfSamples.String = num2str(nSamples/SamplingRate);
    else 
        nSamples = SamplingRate*str2double(handles.NumberOfSamples.String);
        handles.NumberOfSamples.String = num2str(nSamples);
    end
    % Update mode selected (user input)
    nSamplesSelection = selectionIdx;
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Selected ', contents{nSamplesSelection}]);    
end
% --- Executes during object creation, after setting all properties.
function NSamplesPopUp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NSamplesPopUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function NumberOfSamples_Callback(hObject, eventdata, handles)
% hObject    handle to NumberOfSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

samples = get(hObject,'String');
global nSamples SamplingRate
contents = cellstr(get(handles.NSamplesPopUp, 'String'));
selectionIdx = find(ismember(contents, contents{get(handles.NSamplesPopUp,'Value')}));
% Get corresponding number of samples independently of the mode
if selectionIdx == 1, samples = SamplingRate*str2double(samples);
else, samples = str2double(samples); end
% Check if Number of Samples has changed
if nSamples ~= samples
    % Update Number of Samples (user input)
    nSamples = samples;
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['#Samples updated to ', num2str(nSamples), ' (AcquisitionTime ',num2str(nSamples/SamplingRate),' s)']);    
end
% --- Executes during object creation, after setting all properties.
function NumberOfSamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberOfSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in ECGCheckBox.
function ECGCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to ECGCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global analogChannels
% Update check box state
analogChannels(1) = get(hObject,'Value');
txt = 'S'; if get(hObject,'Value') == 0, txt = 'Uns'; end
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['ECG measurement ', txt, 'elected']);    
% --- Executes on button press in PulseCheckBox.
function PulseCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to PulseCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global analogChannels
% Update check box state
analogChannels(2) = get(hObject,'Value');
txt = 'S'; if get(hObject,'Value') == 0, txt = 'Uns'; end
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Pulse measurement ', txt, 'elected']);    
% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% For Matlab versions previous to 2010, run these lines:
javaaddpath(fullfile('/lib/bluecove-2.1.1-SNAPSHOT.jar'));
javaaddpath(fullfile('/lib'));

global SamplingRate mac analogChannels ECGChannel PulseChannel nSamples
analogChannels(1) = handles.ECGCheckBox.Value;
analogChannels(2) = handles.PulseCheckBox.Value;
analogChannels = analogChannels.*[ECGChannel, PulseChannel]; % channel mask
filterChannels = analogChannels(analogChannels ~= 0);
if filterChannels == 0, LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['No measurement selected!']); return; end

% Create Bitalino instance
bit = bitalino();
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Bitalino instance created']);
% Open bluetooth connection with bitalino
bit = bit.open(mac,SamplingRate);
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Opening BT connection instance']);

global DEBUG_MODE;
DEBUG_MODE = false;
if or(bit.connection , DEBUG_MODE)
    time = linspace(0, nSamples/SamplingRate, nSamples);
    global data dataHeader

    if DEBUG_MODE
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Entering in debug mode']);
        % Mock behavior while DEBUG MODE
        dataHeader = {'time', 'SamplingFrequency'};
        data = [time(:), SamplingRate*ones(nSamples,1)];
        if ismember(ECGChannel, filterChannels)
            ecg = sin(2*pi/time(end)*time(:)); 
            data = [data, ecg(:)]; dataHeader{end+1} = 'Sin(x)';
        end
        if ismember(PulseChannel, filterChannels)
            pulse = cos(2*pi/time(end)*time(:));
            data = [data, pulse(:)]; dataHeader{end+1} = 'Cos(x)'; 
        end
    else
        % Get bitalino version
        bit.version();
        pause(2);
        % Start acquisition
        bit = bit.start(filterChannels);
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Starting acquisition']);        
        
        % Read samples
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Reading Bitalino measurements...']);
        readData = bit.read(nSamples);
        if length(readData) == nSamples, LogTrace(handles, datestr(now,'[hh:mm:ss]'), [num2str(nSamples), ' samples read']);
        else, LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Read samples: ', num2str(length(readData)),' Expected: ', num2str(nSamples)]);end
        %stop acquisition
        bit.stop();

        % Format read data
        %global dataHeader
        data = [time(:), SamplingRate*ones(nSamples,1)];
        dataHeader = {'time', 'SamplingFrequency'};
        if ismember(ECGChannel,analogChannels)
            ecg                 = readData(6,:); 
            data                = [data, (ecg(:))];
            dataHeader{end+1}   = 'ECG';
        end
        if ismember(PulseChannel, analogChannels)
            pulse               = readData(7,:); 
            data                = [data, (pulse(:))]; 
            dataHeader{end+1}   = 'Pulse';
        end 
    end
        % Plot channel acquired
        cla(handles.CommonAxes); cla(handles.ECGAxes); cla(handles.PulseAxes);
        if length(filterChannels) > 1
           LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG and Pulse waves']);
           handles.CommonAxes.Visible = 'off'; handles.ECGAxes.Visible = 'on'; handles.PulseAxes.Visible = 'on';
           axes(handles.ECGAxes);
           plot(time,  (ecg)); grid on; ylabel('ECG meas. ');
           axes(handles.PulseAxes);
           plot(time,  (pulse)); grid on; ylabel('Pulse meas. '); xlabel('time [s]');
        else
            handles.CommonAxes.Visible = 'on'; handles.ECGAxes.Visible = 'off'; handles.PulseAxes.Visible = 'off';
            axes(handles.CommonAxes);
            if ismember(ECGChannel,analogChannels)     
                LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG wave']);
                plot(time,  (ecg)); grid on; xlabel('time [s]'); ylabel('ECG meas. ');
            else
                LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting Pulse wave']);
                plot(handles.CommonAxes, time, pulse); grid on; xlabel('time [s]'); ylabel('Pulse meas. ');
            end
        end 
else
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Error while conneting with Bitalino']);
    return
end

%close connection
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Closing Bitalino connection...']);
bit.close();
handles.ExportButton.Enable     = 'on';
handles.ProcessButton.Enable    = 'on';
handles.Filter.Visible          = 'on';
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['System ready to proceed']);



%%%%%%%%%%%%%%%%%%%%%%%%%%% Exporting Features %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in ExportButton.
function ExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global dataHeader dataProcessed
if dataProcessed == 0
    [resultOk, resultsFile] = ExportRawData();
    if resultOk
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Exported data to: ', resultsFile]);
    else, return; 
    end
else
    [resultOk, resultsFile] = ExportProcessedData();
    if resultOk
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Exported filtered data to: ', resultsFile]);
    else, return;
    end
    
    % Exporting figures
    if ExportFigures(handles), LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['All plots correctly saved']); end
               
    % Exporting signals features
    if ExportProcessedResults(resultsFile), LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['All plots correctly saved']); end
    %%%%%%%%%%%%%%%%% ------------------ %%%%%%%%%%%%%%%%%
    %%% TODO: create a .txt file with signal features!
        
    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%% Importing Features %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in ImportButton.
function ImportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ImportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filter = {'*.csv;*.xlsx', 'Supported file types (*.csv, *.xlsx)'};
[file,path,indx] = uigetfile(filter);
if indx == 0, return; end
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Imported data from: ', file]);

handles.tab1.Enable = 'off';
handles.tab2.Enable = 'off';
cla(handles.RRAxes);cla(handles.CommonRRBP);cla(handles.BPAxes);
handles.RRBPPanel.Visible = 'off';
handles.ECGPulsePanel.Visible = 'on';


global data dataHeader
dataTable = readtable([path,file]);
data = dataTable{:,:};
sz = size(data);
for n = 3:sz(2)
    if max(data(:,n)) > 5
        data(:,n) = (data(:,n));
    end
end
dataHeader = dataTable.Properties.VariableNames;

LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Imported data contains: ', strjoin(dataHeader, ',')]);
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting imported data']);
PlotCurrentData(handles);
handles.ProcessButton.Enable = 'on';
handles.Filter.Visible       = 'on';

%%%%%%%%%%%%%%%%%%%%%%%%%%% Processing Features %%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on selection change in Filter.
function Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
filterSelected = contents{get(hObject,'Value')};
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Selected ', filterSelected, ' filter']);

% --- Executes during object creation, after setting all properties.
function Filter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in ProcessButton.
function ProcessButton_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data dataResult dataHeader SamplingRate
dataResult = data;
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Preparing data to process']);
if and(size(data,2)~=length(dataHeader), length(dataHeader)<3), LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Data not processed because an error']); end

global ecgResult pulseResult  time
global ecgQ ecgR ecgS R_pos S_Pos
global pulsePeak
ecgResult = []; pulseResult = []; time = [];
ecgQ = []; ecgR = []; ecgS = [];
pulsePeak = [];

f1 = 2; f2 = 12;                    % Filter cut-off frequencies
Ti = 3;                             % First processing instant
delay = floor(SamplingRate*Ti);     %
wq = floor(0.07*SamplingRate);      % Window size for Q detection
ws = floor(0.07*SamplingRate);      % Window size for S detection

if ismember('time', dataHeader), time = data(:,strcmp('time', dataHeader)); time = time(:)'; else, return; end

selectedFilter = handles.Filter.Value; % 1: None, 2: Butterworth, 3: Eliptic
if ismember('ECG',dataHeader)
    handles.tab1.Enable = 'on';
    handles.tab2.Enable = 'on';
    ecgResult = data(:,strcmp('ECG',dataHeader)); ecgResult = ecgResult(:)';
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['ECG data found. Processing...']);
    % Filtered data
    switch selectedFilter
        case 2
            ecgResult = butterworth_filter(ecgResult,f1,f2,SamplingRate);
        case 3
            ecgResult = elliptic_filter(ecgResult,f1,f2,SamplingRate);
        otherwise            
    end
     dataResult(:,strcmp('ECG',dataHeader)) = ecgResult(:);
    % QRS detection algorithm for ECG
    [R_amp,R_pos,~]     = pan_tompkin_revised(ecgResult(delay:end),SamplingRate,0.2);
    R_pos               = R_pos + delay-1;
    [Q_pos, S_Pos]       = find_Q_S(ecgResult,R_pos,wq,ws);
    ecgQ = time(Q_pos); ecgR = time(R_pos); ecgS = time(S_Pos);
end
if ismember('Pulse',dataHeader)
    pulseResult = data(:,strcmp('Pulse',dataHeader)); pulseResult = pulseResult(:)';
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Pulse data found. Processing...']);
    % Filtered data
    switch selectedFilter
        case 2 
            pulseResult = butterworth_filter(pulseResult,f1,f2,SamplingRate);
        case 3
            pulseResult = elliptic_filter(pulseResult,f1,f2,SamplingRate);
        otherwise
    end
     dataResult(:,strcmp('Pulse',dataHeader)) = pulseResult(:);
    % Peak detector of Pulse signals
    [Pulse_amp,Pulse_pos,~]     = pan_tompkin_revised(pulseResult(delay:end),SamplingRate,0.2);    
    Pulse_pos                   = Pulse_pos + delay-1; 
    pulsePeak = time(Pulse_pos);
end

if isempty(ecgResult) && isempty(pulseResult), LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['No data found!']); return; end

% Plot results
if ~isempty(ecgResult)
    if ~isempty(pulseResult)
        % Both signals are displayed
        cla(handles.CommonAxes); cla(handles.ECGAxes); cla(handles.PulseAxes);
        handles.CommonAxes.Visible = 'off'; handles.ECGAxes.Visible = 'on'; handles.PulseAxes.Visible = 'on';
        axes(handles.ECGAxes);
        plot(time,  (ecgResult)); grid on; hold on; ylabel('ECG processed');xlabel('Time [s]');
        title('Processed data');
        plot(time(R_pos), (ecgResult(R_pos)),'vr'); plot(time(Q_pos), (ecgResult(Q_pos)),'>b'); plot(time(S_Pos), (ecgResult(S_Pos)),'<b');
        ymin = min( (ecgResult(delay:floor(end-SamplingRate*5)))); ymax = max( (ecgResult(delay:floor(end-SamplingRate*5))));
        ymin = ymin-abs(ymax-ymin)*0.1; ymax = ymax+abs(ymax-ymin)*0.1;
        ylim([ymin ymax]);
        hold off;
        legend('ECG filtered','R peaks','Q peaks','S peaks');
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['ECG plotted']);
        axes(handles.PulseAxes);
        plot(time,  (pulseResult)); grid on; hold on; xlabel('Time [s]'); ylabel('Pulse processed');
        plot(time(Pulse_pos), (pulseResult(Pulse_pos)),'vr');
        ymin = min( (pulseResult(delay:floor(end-SamplingRate*5)))); ymax = max( (pulseResult(delay:floor(end-SamplingRate*5))));
        ymin = ymin-abs(ymax-ymin)*0.1; ymax = ymax+abs(ymax-ymin)*0.1;
        ylim([ymin ymax]);
        hold off;
        legend('Pulse filtered','Pulse peaks');
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Pulse plotted']);
    else
        cla(handles.CommonAxes); cla(handles.ECGAxes); cla(handles.PulseAxes);
        handles.CommonAxes.Visible = 'on'; handles.ECGAxes.Visible = 'off'; handles.Pulse.Visible = 'off';
        axes(handles.CommonAxes);
        plot(time,  (ecgResult)); grid on; hold on; ylabel('ECG processed '); xlabel('time [s]');
        title('Processed data');
        plot(time(R_pos), (ecgResult(R_pos)),'vr'); plot(time(Q_pos), (ecgResult(Q_pos)),'>b'); plot(time(S_Pos), (ecgResult(S_Pos)),'<b');
        ymin = min( (ecgResult(delay:floor(end-SamplingRate*5)))); ymax = max( (ecgResult(delay:floor(end-SamplingRate*5))));
        ymin = ymin-abs(ymax-ymin)*0.1; ymax = ymax+abs(ymax-ymin)*0.1;
        ylim([ymin ymax]);
        hold off;
        legend('ECG filtered','R peaks','Q peaks','S peaks');
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['ECG plotted']);
    end
else
    cla(handles.CommonAxes); cla(handles.ECGAxes); cla(handles.PulseAxes);
    handles.CommonAxes.Visible = 'on'; handles.ECGAxes.Visible = 'off'; handles.Pulse.Visible = 'off';
    axes(handles.CommonAxes);
    plot(time,  (pulseResult)); grid on; hold on; xlabel('time [s]'); ylabel('Pulse processed ');
    plot(time(Pulse_pos), (pulseResult(Pulse_pos)),'vr');
    ymin = min( (pulseResult(delay:floor(end-SamplingRate*5)))); ymax = max( (pulseResult(delay:floor(end-SamplingRate*5))));
    ymin = ymin-abs(ymax-ymin)*0.1; ymax = ymax+abs(ymax-ymin)*0.1;
    ylim([ymin ymax]);
    hold off;
    legend('Pulse filtered','Pulse peaks');
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Pulse plotted']);    
end
% Extracting signal features
ExtractSignalFeatures(handles);
PlotSignalFeatures(handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Other functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ExtractSignalFeatures(handles)

global dataHeader SamplingRate

global ecgResult pulseResult time
global ecgQ ecgR ecgS
global pulsePeak

global ecgHeartRate ecgHeartRate20sAvg
global pulseHeartRate pulseHeartRate20sAvg
global arrivalTime arrivalTimeAvg SBP DBP
ecgHeartRate    = []; ecgHeartRate20sAvg = -1;
pulseHeartRate  = []; pulseHeartRate20sAvg = -1;
arrivalTime     = []; arrivalTimeAvg = -1;

% Beat rate calculation QRS
if ismember('ECG', dataHeader)
    ecgHeartRate = 1./diff(ecgR); 
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), 'Beat rate calculated from ECG');
    
    ti = ecgR(2);    
    [~,nf] = min(abs(time-(ti+20)));
    tf = time(nf);
    nRi = 0;
    [~,nRf] = min(abs(ecgR-tf));
    
    if ecgR(nRf)>tf, nRf = nRf-1; end    
    ecgHeartRate20sAvg = abs( (nRf-nRi)/(tf-ti) );    
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Beat rate average calculated from ECG (',num2str(ecgHeartRate20sAvg),' bps)']);

end
% Beat rate calculation Pulse Peak
if ismember('Pulse', dataHeader)
    pulseHeartRate = 1./diff(pulsePeak); 
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), 'Beat rate calculated from Pulse');
    
    ti = pulsePeak(2);    
    [~,nf] = min(abs(time-(ti+20)));
    tf = time(nf);
    nRi = 0;
    [~,nRf] = min(abs(pulsePeak-tf));
    
    if pulsePeak(nRf)>tf, nRf = nRf-1; end    
    pulseHeartRate20sAvg = abs( (nRf-nRi)/(tf-ti) ); 
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Beat rate average calculated from Pulse (',num2str(pulseHeartRate20sAvg), ' bps)']);
end
% Arrival time and Blood Pressure
if ismember('ECG', dataHeader) && ismember('Pulse', dataHeader)
    Rs = ecgR(ecgR<pulsePeak(end));
    Ps = pulsePeak(pulsePeak>ecgR(1));    
    if length(Rs) ~= length(Ps), LogTrace(handles, datestr(now,'[hh:mm:ss]'), 'Pulse Peaks and ECG R Peaks array have different lengths'); return;end
    arrivalTime = abs(Ps-Rs);
    arrivalTimeAvg = mean(arrivalTime);
    
    DBP0 = 77; SBP0 = 124; PTT0 = 0.3; A = 1;
    for i = 1:length(arrivalTime)
        PTT = arrivalTime(i);
        DBP(i) = (SBP0/3) + 2*DBP0/3 + A*log(PTT0/PTT) - (SBP0-DBP0)*PTT0^2/(3*PTT^2);
        SBP(i) = DBP(i) + (SBP0-DBP0)*(PTT0)^2/(PTT)^2;
    end
    DBPavg = mean(DBP);
    SBPavg = mean(SBP);
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Diastolic blood pressure (DBP):',num2str(DBPavg),' mmHg']);
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Systolic blood pressure (SBP):',num2str(SBPavg),' mmHg']);
end
handles.ExportButton.Enable = 'on';
global dataProcessed
dataProcessed = 1;


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clc; clear all; close all;


% --- Executes on button press in tab1.
function tab1_Callback(hObject, eventdata, handles)
handles.RRBPPanel.Visible = 'off';
handles.ECGPulsePanel.Visible = 'on';




% --- Executes on button press in tab2.
function tab2_Callback(hObject, eventdata, handles)
handles.RRBPPanel.Visible = 'on';
handles.ECGPulsePanel.Visible = 'off';

