function y = butterworth_filter(signal,lowF,highF,Fs)

Fstop1 = lowF-1;     % First Stopband Frequency
Fpass1 = lowF;     % First Passband Frequency
Fpass2 = highF;    % Second Passband Frequency
Fstop2 = highF+10;    % Second Stopband Frequency
Astop1 = 10;    % First Stopband Attenuation (dB)
Apass  = 1;     % Passband Ripple (dB)
Astop2 = 40;    % Second Stopband Attenuation (dB)
match  = 'stopband';
 % Sampling Frequency

h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

sz_original = size(signal);

R=0.1; % 10% of signal
Nr=1000;
N=size(signal,2);
NR=min(round(N*R),Nr); % At most 50 points
for i=1:size(signal,1)
    signal1(i,:)=2*signal(i,1)-flipud(signal(i,2:NR+1));  % maintain continuity in level and slope
    signal2(i,:)=2*signal(i,end)-flipud(signal(i,end-NR:end-1));
end
signal=[signal1,signal,signal2];
% Do filtering
sz_extended=size(signal);
y=zeros(sz_original);
z=zeros(sz_extended);
for i=1:sz_original(1)
    z(i,:)=filtfilt(Hd.sosMatrix,Hd.ScaleValues,signal(i,:));
    y(i,:)=z(:,NR+1:end-NR);
end
u=0;    
