function [peakI,peakAmp]=findQRSpeaks(ecg,win)

L=length(ecg);
peakI=zeros(size(ecg));
for i=(1+win):(L-win)
    [M,I]=max(ecg(i-win:i+win));
    if i==(i-win-1+I) 
        peakI(i)=1;
    end
end
peakI=find(peakI>0);
peakAmp=ecg(peakI);
    


