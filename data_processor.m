clear all; close all; clc;


SamplingRate = 100;
nSamples = 4000;
Ti = 10;
wq = 0.07*SamplingRate;
ws = 0.07*SamplingRate;

time = linspace(0,nSamples/SamplingRate,nSamples);
ecg = csvread('ECG_2_100Fs_40s.csv');
ecg_eliptic = elliptic_filter(ecg,2,30,SamplingRate);
ecg_butterworth = butterworth_filter(ecg,2,30,SamplingRate);

pulse = csvread('Pulse_1_100Fs_40s.csv');
pulse_eliptic = elliptic_filter(pulse,2,20,SamplingRate);
pulse_butterworth = butterworth_filter(pulse,2,20,SamplingRate);

%% TEST CODE FOR COMBINED ACQUISITION
combi = csvread('ECG_Pulse_2_100Fs_40s.csv');
ecg = combi(1,:);
ecg_butterworth = butterworth_filter(ecg,2,20,SamplingRate);
pulse = combi(2,:);
pulse_butterworth = butterworth_filter(pulse,2,20,SamplingRate);


%% Peak detector of Pulse signals
[Pulse_amp,Pulse_pos,delay] = pan_tompkin_revised(pulse,SamplingRate);
[Pulse_el_amp,Pulse_el_pos,delay] = pan_tompkin_revised(pulse_eliptic(floor(SamplingRate*Ti):end),SamplingRate);
[Pulse_bt_amp,Pulse_bt_pos,delay] = pan_tompkin_revised(pulse_butterworth(floor(SamplingRate*Ti):end),SamplingRate);
Pulse_el_pos = Pulse_el_pos + floor(SamplingRate*Ti-1);
Pulse_bt_pos = Pulse_bt_pos + floor(SamplingRate*Ti-1);

% TEST COMBINED
[QPulse_pos] = find_Q_S(pulse_butterworth(floor(SamplingRate*Ti):end),Pulse_bt_pos-floor(SamplingRate*Ti-1),wq*2,ws);
QPulse_pos = QPulse_pos + floor(SamplingRate*Ti-1);

%% QRS detection algorithm for ECG
[R_amp,R_pos,delay] = pan_tompkin_revised(ecg,SamplingRate);
[Q_pos,S_pos] = find_Q_S(ecg,R_pos,wq,ws);

[R_el_amp,R_el_pos,delay] = pan_tompkin_revised(ecg_eliptic(floor(SamplingRate*Ti):end),SamplingRate);
[Q_el_pos,S_el_pos] = find_Q_S(ecg_eliptic(floor(SamplingRate*Ti):end),R_el_pos,wq,ws);
R_el_pos = R_el_pos + floor(SamplingRate*Ti-1);
Q_el_pos = Q_el_pos + floor(SamplingRate*Ti-1);
S_el_pos = S_el_pos + floor(SamplingRate*Ti-1);

[R_bt_amp,R_bt_pos,delay] = pan_tompkin_revised(ecg_butterworth(floor(SamplingRate*Ti):end),SamplingRate);
[Q_bt_pos,S_bt_pos] = find_Q_S(ecg_butterworth(floor(SamplingRate*Ti):end),R_bt_pos,wq,ws);
R_bt_pos = R_bt_pos + floor(SamplingRate*Ti-1);
Q_bt_pos = Q_bt_pos + floor(SamplingRate*Ti-1);
S_bt_pos = S_bt_pos + floor(SamplingRate*Ti-1);


%% Pulse peak representation
figure('name','Original pulse');plot(time,pulse);title('Pulse');hold on;
plot(time(Pulse_pos),Pulse_amp,'xR','LineWidth',2); hold on;
hold off;

figure('name','Elliptic filtered pulse');plot(time,pulse_eliptic);title('Elliptic Pulse');hold on;
plot(time(Pulse_el_pos),Pulse_el_amp,'xR','LineWidth',2); hold on;
hold off;

figure('name','Butterworth filtered pulse');plot(time,pulse_butterworth);title('Butterworth pulse');hold on;
plot(time(Pulse_bt_pos),Pulse_bt_amp,'xR','LineWidth',2); hold on;
hold off;

%% QRS representation of ECG signals
figure('name','Original ECG');plot(time,ecg);title('ECG');hold on;
plot(time(R_pos),R_amp,'xR','LineWidth',2); hold on;
plot(time(Q_pos),ecg(Q_pos),'xB','LineWidth',2); hold on;
plot(time(S_pos),ecg(S_pos),'xG','LineWidth',2);
hold off;

figure('name','Eliptic filtered ECG');plot(time,ecg_eliptic);ylim([-300,300]);title('ECG Eliptic');hold on;
plot(time(R_el_pos),R_el_amp,'xR','LineWidth',2); hold on;
plot(time(Q_el_pos),ecg_eliptic(Q_el_pos),'xB','LineWidth',2); hold on;
plot(time(S_el_pos),ecg_eliptic(S_el_pos),'xG','LineWidth',2); yline(0,'LineWidth',2);
hold off;

figure('name','Butterworth filtered ECG');plot(time,ecg_butterworth);ylim([-300,300]);title('ECG Butterworth');hold on;
plot(time(R_bt_pos),R_bt_amp,'xR','LineWidth',2); hold on;
plot(time(Q_bt_pos),ecg_butterworth(Q_bt_pos),'xB','LineWidth',2); hold on;
plot(time(S_bt_pos),ecg_butterworth(S_bt_pos),'xG','LineWidth',2); yline(0,'LineWidth',2);
hold off;

%% Combined Butterworth signals
figure('name','Butterworth filtered ECG and Pulse');plot(time,ecg_butterworth);ylim([-300,300]);title('Butterworth filtered ECG and Pulse');hold on;
plot(time(R_bt_pos),R_bt_amp,'xR','LineWidth',2); hold on;
plot(time,pulse_butterworth);hold on;
plot(time(Pulse_bt_pos),Pulse_bt_amp,'xR','LineWidth',2); hold on;
plot(time(QPulse_pos),pulse_butterworth(QPulse_pos),'xY','LineWidth',2);
hold off;

%% Beat rate calculation QRS
% [P_pos,T_pos] = find_P_T(ecg_eliptic,Q_pos,S_pos,120,300,SamplingRate);   
br = 1./diff(time(R_pos));
br_el = 1./diff(time(R_el_pos));
br_bt = 1./diff(time(R_bt_pos));

%% Beat rate calculation QRS
br_el_pulse = 1./diff(time(Pulse_el_pos));
br_bt_pulse = 1./diff(time(Pulse_bt_pos));

%% Arrival time
if(size(Pulse_bt_pos,2)~=size(R_bt_pos,2))
    if(Pulse_bt_pos(1)<R_bt_pos)
        Pulse_bt_pos = Pulse_bt_pos(2:end);
    else
        R_bt_pos = R_bt_pos(1:end-1);
    end 
elseif(Pulse_bt_pos(1)<R_bt_pos)
    Pulse_bt_pos = Pulse_bt_pos(2:end);
    R_bt_pos = R_bt_pos(1:end-1);
end

AT = time(Pulse_bt_pos-R_bt_pos);
meanAT = mean(AT)
