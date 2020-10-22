function [QRtoQS,RStoQS]= find_QRtoQS_RStoQS(Q,R,S)

zeros(1,length(R));
for i=1:length(R)
    QRtoQS(i)= (R(i)-Q(i))/(S(i)-Q(i));
    RStoQS(i)= (S(i)-R(i))/(S(i)-Q(i));
end