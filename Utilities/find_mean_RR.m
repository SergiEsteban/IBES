function RR_mean = find_mean_RR(QRS_array_i)

RR_interval=[];
for j=1:length(QRS_array_i)-1
    RR_interval=[RR_interval QRS_array_i(j+1)-QRS_array_i(j)];    
end  
RR_mean = mean(RR_interval);