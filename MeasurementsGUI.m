

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

% Edit the above text to modify the response to help MeasurementsGUI

% Last Modified by GUIDE v2.5 22-Oct-2020 15:09:58

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
% End initialization code - DO NOT EDIT
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
clc;
% Default Values

global SamplingRate mac  analogChannels nSamples nSamplesSelection
SamplingRate        = 100;
mac                 = '98D371FD61F2';
analogChannels      = 1;
nSamples            = 5000;
nSamplesSelection   = 2;

handles.SamplingFrequency.Value     = 2; % 100 Hz
handles.MACaddr.String              = mac;
handles.Channel.Value               = analogChannels; % Channel 1
handles.NSamplesPopUp.Value         = nSamplesSelection;    % Number of Samples
handles.NumberOfSamples.String      = num2str(nSamples);

handles.Logger.String = '';
LogTrace(handles, '', ['LogSession: ', datestr(now, 'dd/MM/yyyy')]); % first blank line
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
function SamplingFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to SamplingFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SamplingFrequency contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SamplingFrequency
contents    = cellstr(get(hObject,'String'));
Fs          = contents{get(hObject,'Value')};
global SamplingRate
if SamplingRate ~= str2num(Fs)
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
function MACaddr_Callback(hObject, eventdata, handles)
% hObject    handle to MACaddr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MACaddr as text
%        str2double(get(hObject,'String')) returns contents of MACaddr as a double
content    = cellstr(get(hObject,'String')); content = strtrim(content{1});
global mac
if ~strcmp(mac,content);
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
% --- Executes on selection change in Channel.
function Channel_Callback(hObject, eventdata, handles)
% hObject    handle to Channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Channel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Channel
contents    = cellstr(get(hObject,'String'));
Channel     = contents{get(hObject,'Value')};
global analogChannels
if analogChannels ~= str2num(Channel)
    analogChannels = str2num(Channel);
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['AnalogChannel updated to ', num2str(analogChannels)]);
end
% --- Executes during object creation, after setting all properties.
function Channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel (see GCBO)
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

% Hints: contents = cellstr(get(hObject,'String')) returns NSamplesPopUp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NSamplesPopUp
contents    = cellstr(get(hObject,'String'));
selection   = contents{get(hObject,'Value')};
selectionIdx= find(ismember(contents, selection));
global nSamplesSelection nSamples SamplingRate
if nSamplesSelection ~= selectionIdx
    if selectionIdx == 1
%        nSamples = SamplingRate*str2num(handles.NumberOfSamples.String);
        handles.NumberOfSamples.String = num2str(nSamples/SamplingRate);
    else
        nSamples = SamplingRate*str2num(handles.NumberOfSamples.String);
        handles.NumberOfSamples.String = num2str(nSamples);
    end
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

% Hints: get(hObject,'String') returns contents of NumberOfSamples as text
%        str2double(get(hObject,'String')) returns contents of NumberOfSamples as a double
samples = get(hObject,'String');
global nSamples SamplingRate
contents = cellstr(get(handles.NSamplesPopUp, 'String'));
selectionIdx = find(ismember(contents, contents{get(handles.NSamplesPopUp,'Value')}));
if selectionIdx == 1, samples = SamplingRate*str2num(samples);
else, samples = str2num(samples); end
if nSamples ~= samples
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
% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% For Matlab versions previous to 2010, run these lines:
javaaddpath(fullfile('/lib/bluecove-2.1.1-SNAPSHOT.jar'));
javaaddpath(fullfile('/lib'));

global SamplingRate mac analogChannels nSamples

% Create Bitalino instance
bit = bitalino();
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Bitalino instance created']);
% Open bluetooth connection with bitalino
bit = bit.open(mac,SamplingRate);
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Opening BT connection instance']);

if bit.connection
    % Get bitalino version
    bit.version();
    pause(2);
    % Start acquisition on channel A4
    bit = bit.start(analogChannels);
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Starting acquisition']);
    % Making visible the figure
    handles.ReadAxes.Visible = 'on';
    time = linspace(0, nSamples/SamplingRate, nSamples);
    handles.ReadAxes.xlim = [time(1) time(end)];
    % Read samples
    readData = bit.read(nSamples);
    if length(readData) == nSamples, LogTrace(handles, datestr(now,'[hh:mm:ss]'), [num2str(nSamples), ' samples read']);
    else, LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Read samples: ', num2str(length(readData)),' Expected: ', num2str(nSamples)]);end
    %stop acquisition
    bit.stop();
    
    % Plot channel acquired
    ecg = readData(6,:); 
    global data
    data = [time(:), ecg(:), SamplingRate*ones(nSamples,1)];
    handles.ExportButton.Visible = 'on';
    axes(handles.ReadAxes);
    title('Measured ECG'); xlabel('time / s'); grid on;
    plot(time,ecg);    
else
    LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Error while conneting with Bitalino']);
    return
end

%close connection
bit.close();

function LogTrace(handles, ts, trace)
txt         = cellstr(get(handles.Logger,'String'));
txt{end+1,1}  = [ts, ' ', trace];
set(handles.Logger,'String', txt);
    


% --- Executes on button press in ExportButton.
function ExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data
filter = {'*.csv;*.xlsx', 'Supported file types (*.csv, *.xlsx)'; '*.*','All files (*.*)'};
[file, path] = uiputfile(filter, 'Export ECG', 'ECG measurement.csv');
csvwrite([file, path], data);
LogTrace(handles, datestr(now,'[hh:mm:ss]'), ['Exported data to: ', file]);


