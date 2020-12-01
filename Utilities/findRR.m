function [momentI,momentAmp]=findRR(ecg,Rpos,fs)

L=length(ecg);
momentI=zeros(size(ecg));
win = 0.02*fs;
step = win/4;
pos = 0;

for i = (1+step):(L-step)
    momentA = moment(ecg(i-win,i+win),4);
    if i==(i-win-1+Rpos(pos))
        pos = pos + 1;
        
    end
end