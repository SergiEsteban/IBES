function [P_i, T_i]=find_P_T(signal,Q_i,S_i,PLength, TLength,fs)

P_i = [];
T_i = [];
S_T = [];

for j=1:length(Q_i)
    
    if Q_i(j)>PLength && S_i(j)< length(signal)-TLength
     [P_value,Pi]= max(signal(Q_i(j)-PLength:Q_i(j)));     
     P_i=[P_i (Q_i(j)-PLength+Pi)];
     [T_value,Ti]= max(signal(S_i(j)+0.08*fs:S_i(j)+TLength));
       if ~isnan(T_i)
        
           mean8S_T = sum(T_i(end-min(7,length(T_i)-1) : end)-S_i(length(T_i)-min(7,length(T_i)-1) : length(T_i)))/(min(7,length(T_i)-1)+1);
             if (Ti+80 )> (mean8S_T * 0.8)
                 T_i=[T_i (S_i(j)+ 0.08*fs + Ti)];     
             else                 
                [Maxima,MaxIdx] = findpeaks(signal(S_i(j)+ round(mean8S_T *0.8) : S_i(j) + TLength));
                if ~isnan(MaxIdx)
                  [Max,index] = max(Maxima);
                  T_i=[T_i (S_i(j)+ round(mean8S_T*0.8)+ MaxIdx(index))];
              
                else
                  T_i=[T_i (S_i(j)+ 0.08*fs + Ti)];
                end
             end
    
      else
         T_i=[T_i (S_i(j)+ 0.08*fs + Ti)];
      end
   else 
        T_i(j)=-1;
        P_i(j)=-1;
    end
end
T_i=T_i(find(T_i ~= -1));
P_i=P_i(find(P_i ~= -1));

   