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
sz=size(signal);
y=zeros(sz);
for i=1:sz(1)
    y(i,:)=filtfilt(Hd.sosMatrix,Hd.ScaleValues,signal(i,:));
end
u=0;   
