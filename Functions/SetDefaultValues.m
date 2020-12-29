function SetDefaultValues(handles)
% SetDefaultValues sets the default values to the GUI interface

% -- Default Values 
global SamplingRate mac ECGChannel PulseChannel analogChannels nSamples nSamplesSelection dataProcessed

dataProcessed       = 0;
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
handles.Filter.Visible      = 'off';

handles.Logger.String = "";

end

