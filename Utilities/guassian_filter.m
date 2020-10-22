function  y = guassian_filter(signal,N,alpha)

gaussFilter = gausswin(N,alpha);
gaussFilter = gaussFilter / sum(gaussFilter);
sz=size(signal);
y=zeros(sz);
for i=1:sz(1)
    y(i,:) = filtfilt(gaussFilter,1,signal(i,:));
end
u=0;
