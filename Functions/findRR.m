function [momentAmp]=findRR(ecg,Rpos,Spos)

momentAmp=zeros(size(Rpos));
for i = 1:length(Rpos)
    momentAmp(i) = moment(ecg(Rpos(i):Spos(i)),4);   
end