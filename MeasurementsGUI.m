
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
DEBUG_MODE = 1;

% -- Default Values 
global SamplingRate mac ECGChannel PulseChannel analogChannels nSamples nSamplesSelection

SamplingRate        = 100;              % Hz
mac                 = '98D371FD61F2';   % Bitalino MAC address
ECGChannel          = 1;                % AnalogChannel 2
PulseChannel        = 5;                % AnalogChannel 6 
nSamples            = 5000;             % Samples Number
nSamplesSelection   = 2;                % 'Number of Samples' mode

handles.SamplingFrequency.Value     = 2; % 100 Hz
handles.MACaddr.String              = mac;
handles.NSamplesPopUp.Value         = nSamplesSelection;    % Number of Samples
handles.NumberOfSamples.String      = num2str(nSamples);
handles.ECGCheckBox.Value           = 1;                    % Default ECG meas
handles.PulseCheckBox.Value         = 0;
analogChannels                      = [1, 0];

handles.CommonAxes.Visible  = 'off'; cla(handles.CommonAxes);
handles.ECGAxes.Visible     = 'off'; cla(handles.ECGAxes);
handles.PulseAxes.Visible   = 'off'; cla(handles.PulseAxes);

handles.ExportButton.Enable = 'off';
handles.ProcessButton.Enable= 'off';

handles.Logger.String = "";
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
% --- Executes on selection change in SamplingFrequency.



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
if SamplingRate ~= str2num(Fs)
    % Update Sampling Frequency (user input)
    SamplingRate = str2num(Fs);
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
        nSamples = SamplingRate*str2num(handles.NumberOfSamples.String);
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

function NumberOfSamples_Callback(hObject, eventdata, handles)
% hObject    handle to NumberOfSamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

samples = get(hObject,'String');
global nSamples SamplingRate
contents = cellstr(get(handles.NSamplesPopUp, 'String'));
selectionIdx = find(ismember(contents, contents{get(handles.NSamplesPopUp,'Value')}));
% Get corresponding number of samples independently of the mode
if selectionIdx == 1, samples = SamplingRate*str2num(samples);
else, samples = str2num(samples); end
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

global DEBUG_MODE
if or(bit.connection , DEBUG_MODE)
    time = linspace(0, nSamples/SamplingRate, nSamples);
    global data dataHeader

    if DEBUG_MODE
        % Mock behavior while DEBUG MODE
        dataHeader = {'time', 'Sampling Frequency'};
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
        global dataHeader
        data = [time(:), SamplingRate*ones(nSamples,1)];
        dataHeader = {'time', 'Sampling Frequency'};
        if ismember(ECGChannel,analogChannels)
            ecg                 = readData(6,:); 
            data                = [data, ecg(:)];
            dataHeader{end+1}   = 'ECG';
        end
        if ismember(PulseChannel, analogChannels)
            pulse               = readData(7,:); 
            data                = [data, pulse(:)]; 
            dataHeader{end+1}   = 'Pulse';
        end 
    end
        % Plot channel acquired
        cla(handles.CommonAxes); cla(handles.ECGAxes); cla(handles.PulseAxes);
        if length(filterChannels) > 1
           LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG and Pulse waves']);
           handles.CommonAxes.Visible = 'off'; handles.ECGAxes.Visible = 'on'; handles.PulseAxes.Visible = 'on';
           axes(handles.ECGAxes);
           plot(time, ecg); grid on; ylabel('ECG meas.');
           axes(handles.PulseAxes);
           plot(time, pulse); grid on; ylabel('Pulse meas.'); xlabel('time [s]');
        else
            handles.CommonAxes.Visible = 'on'; handles.ECGAxes.Visible = 'off'; handles.PulseAxes.Visible = 'off';
            axes(handles.CommonAxes);
            if ismember(ECGChannel,analogChannels)     
                LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG wave']);
                plot(time, ecg); grid on; xlabel('time [s]'); ylabel('ECG meas.');
            else
                LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting Pulse wave']);
                plot(handles.CommonAxes, time, pulse); grid on; xlabel('time [s]'); ylabel('Pulse meas.');
            end
        end 
else
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Error while conneting with Bitalino']);
    return
end

%close connection
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Closing Bitalino connection...']);
bit.close();
handles.ExportButton.Enable = 'on';
handles.ProcessButton.Enable = 'on';
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['System ready to proceed']);



%%%%%%%%%%%%%%%%%%%%%%%%%%% Exporting Features %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in ExportButton.
function ExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data dataHeader
filter = {'*.csv;*.xlsx', 'Supported file types (*.csv, *.xlsx)'};
[file, path, idx] = uiputfile(filter, 'Export ECG', 'ECG measurement.csv');
if idx == 0, return; end
if ~strcmp('.csv', file(end-3:end)), file = [file, '.csv']; end

dataHeader = strjoin(dataHeader,';');
% Write header to file
fid = fopen([path,file],'w'); 
fprintf(fid,'%s\n',dataHeader);
fclose(fid);
%write data to end of file
dlmwrite([path,file], data, '-append', 'delimiter',';');
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Exported data to: ', file]);

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

global data dataHeader
dataTable = readtable([path,file]);
data = dataTable{:,:};
dataHeader = dataTable.Properties.VariableNames;
if ~isempty(dataTable.Properties.VariableDescriptions), dataHeader = dataTable.Properties.VariableDescriptions; end

LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Imported data contains: ', strjoin(dataHeader, ',')]);
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting imported data']);
PlotCurrentData(handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Processing Features %%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in ProcessButton.
function ProcessButton_Callback(hObject, eventdata, handles)
% hObject    handle to ProcessButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data dataHeader DEBUG_MODE
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Preparing data to process']);
if and(size(data,2)~=length(dataHeader), length(dataHeader)<3), LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Data not processed because an error']); end

ecg = []; pulse = [];

if DEBUG_MODE
   if ismember('Sin(x)',dataHeader), ecg = data(:,find(strcmp('Sin(x)',dataHeader))); end
   if ismember('Cos(x)',dataHeader), pulse = data(:,find(strcmp('Cos(x)',dataHeader)));end       
else
   if ismember('ECG',dataHeader), ecg = data(:,find(strcmp('ECG',dataHeader))); end
   if ismember('Pulse',dataHeader), pulse = data(:,find(strcmp('Pulse',dataHeader)));end       
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Other functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LogTrace(handles, ts, trace)
txt         = cellstr(get(handles.Logger,'String'));
txt{end+1,1}  = [ts, ' ', trace];
set(handles.Logger,'String', txt);

function PlotCurrentData(handles)
% Plot channel acquired
cla(handles.CommonAxes); cla(handles.ECGAxes); cla(handles.PulseAxes);
global data dataHeader SamplingRate DEBUG_MODE

time = data(:,find(strcmp(dataHeader,'time')));
SamplingRate = data(1, find(strcmp(dataHeader,'Sampling Frequency')));
if length(dataHeader) > 3
   LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG and Pulse waves']);
   handles.CommonAxes.Visible = 'off'; handles.ECGAxes.Visible = 'on'; handles.PulseAxes.Visible = 'on';
   axes(handles.ECGAxes);
   %if DEBUG_MODE, ecg = data(:,find(strcmp(dataHeader, 'Sin(x)'))); else
   ecg = data(:,find(strcmp(dataHeader,'ECG'))); %end
   %if DEBUG_MODE, pulse = data(:,find(strcmp(dataHeader, 'Cos(x)')));else
       pulse = data(:,find(strcmp(dataHeader,'Pulse'))); %end
   plot(time(:), ecg(:)); grid on; ylabel('ECG meas.');
   title(['Imported Data (SamplingFrequency: ', num2str(SamplingRate),' Hz)']);
   axes(handles.PulseAxes);
   plot(time(:), pulse(:)); grid on; ylabel('Pulse meas.'); xlabel('time [s]');
elseif length(dataHeader) >2
    handles.CommonAxes.Visible = 'on'; handles.ECGAxes.Visible = 'off'; handles.PulseAxes.Visible = 'off';
    axes(handles.CommonAxes);    
    if ismember('ECG',dataHeader)     
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting ECG wave']);           
        ecg = data(:,find(strcmp(dataHeader,'ECG')));
        plot(time(:), ecg(:)); grid on; xlabel('time [s]'); ylabel('ECG meas.');
    else
        LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Plotting Pulse wave']);            
        pulse = data(:,find(strcmp(dataHeader,'Pulse')));
        plot(time(:), pulse(:)); grid on; xlabel('time [s]'); ylabel('Pulse meas.');
    end
        
end 
