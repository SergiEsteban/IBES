clear all; close all; clc;


SamplingRate = 1000;
nSamples = 10000;
wq = 70;
ws = 70;

time = linspace(0,nSamples/SamplingRate,nSamples);
ecg = xlsread('ECG_8_EIND_Triangle_1000Fs');
ecg_eliptic = elliptic_filter(ecg,5,30,SamplingRate);
ecg_butterworth = butterworth_filter(ecg,5,30,SamplingRate);

[R_amp,R_pos,delay] = pan_tompkin_revised(ecg,SamplingRate);
[Q_pos,S_pos] = find_Q_S(ecg,R_pos,wq,ws);

[R_el_amp,R_el_pos,delay] = pan_tompkin_revised(ecg_eliptic,SamplingRate);
[Q_el_pos,S_el_pos] = find_Q_S(ecg_eliptic,R_el_pos,wq,ws);

[R_bt_amp,R_bt_pos,delay] = pan_tompkin_revised(ecg_butterworth(1314:end),SamplingRate);
[Q_bt_pos,S_bt_pos] = find_Q_S(ecg_butterworth(1314:end),R_bt_pos,wq,ws);
R_bt_pos = R_bt_pos + 1313;
Q_bt_pos = Q_bt_pos + 1313;
S_bt_pos = S_bt_pos + 1313;

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

% [P_pos,T_pos] = find_P_T(ecg_eliptic,Q_pos,S_pos,120,300,SamplingRate);   
br = 1./diff(time(R_pos));
br_el = 1./diff(time(R_el_pos));
br_bt = 1./diff(time(R_bt_pos));

