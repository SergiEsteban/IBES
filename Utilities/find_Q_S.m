function [Q_i , S_i]= find_Q_S(signal,QRS_array_i,wq,ws)
    
Q_i = [];
S_i = [];

signalInverse = 1.01*max(signal) - signal;
diffSignal=diff(signal);
for j=1:length(QRS_array_i)     
    [Minima1,MinIdx1] = findpeaks(signalInverse(max(QRS_array_i(j)-wq,0):QRS_array_i(j)));
    if ~isempty(MinIdx1)
        Q_i=[Q_i (QRS_array_i(j)-wq+MinIdx1(end)-1)];
    else
        [Q_value,Qi]= min(signal(QRS_array_i(j)-wq:QRS_array_i(j)));
        Q_i=[Q_i (QRS_array_i(j)-wq+Qi-1)];
    end
    [Minima2,MinIdx2] = findpeaks(signalInverse(QRS_array_i(j):min((QRS_array_i(j)+ws),length(signalInverse))));
    if ~isempty(MinIdx2)   
            S_i=[S_i (QRS_array_i(j)+ MinIdx2(1)-1)];
    else
            [S_value,Si]= min(signal(QRS_array_i(j):QRS_array_i(j)+ws));
            S_i=[S_i (QRS_array_i(j)+Si-1)];
    end
    end
end

   