function y = elliptic_filter(signal,lowF,highF,Fs)
Fstop1 = lowF-1;       % First Stopband Frequency
Fpass1 = lowF;       % First Passband Frequency
Fpass2 = highF;      % Second Passband Frequency
% Fstop2 = highF+10;
Fstop2 = 1.3*highF;% Second Stopband Frequency
Astop1 = 60;      % First Stopband Attenuation (dB)
Apass  = 1;       % Passband Ripple (dB)
Astop2 = 80;      % Second Stopband Attenuation (dB)
match  = 'both';  % Band to match exactly

% Construct an FDESIGN object and call its ELLIP method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'ellip', 'MatchExactly', match);

sz=size(signal);
y=zeros(sz);
for i=1:sz(1)
    y(i,:)=filtfilt(Hd.sosMatrix,Hd.ScaleValues,signal(i,:));
end
u=0;    