function beat2beat_segmentation(signal,QRS_array_i,cutoff_F,Fs,st)

highpassFiltered = elliptic_filter_highpass(signal,cutoff_F,Fs);
smooth = guassian_filter(highpassFiltered,35,6);
[Q_i , S_i]= find_Q_S(smooth,QRS_array_i,.07*Fs,.07*Fs);
[P_i, T_i]=find_P_T(smooth,Q_i,S_i,0.12*Fs, 0.3*Fs,Fs);
T_i=T_i(find(T_i ~= -1));
P_i=P_i(find(P_i ~= -1));
t=(1:length(smooth))/Fs;
%bit2voltData=convertBit2mV_bitalino_ECG(smooth);
bit2voltData=convertBit2mV_bitalino_ECG(signal);
figure
plot(t,bit2voltData,'b');
hold on
yL = get(gca,'YLim');

for i=1:(length(T_i)-1)
    plot([round((T_i(i)+P_i(i+1))/2) round((T_i(i)+P_i(i+1))/2)]/Fs,yL,'r')
end

title(st);
xlabel('Time (s)');
ylabel('Amplituse (mV)');