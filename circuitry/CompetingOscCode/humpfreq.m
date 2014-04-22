function [mfrq,stdpers] = humpfreq(data,time,thr)

[tl,m] = size(data);
if tl ~= length(time)
    if m == length(time)
        data = data';
        [tl,m] = size(data);
    else
        disp('ERROR: data and time mismatch')
    end
end

datath = data-thr;

sdat = sign(datath);
thrc = diff(sdat);
thrc(isnan(thrc))=0;
mpers = zeros(1,m);
stdpers = zeros(1,m);

for i = 1:m
    ONi = (find(thrc(:,i)>0));
    ONt = time(ONi+1);
    pers = diff(ONt);
    mpers(i) = mean(pers);
    stdpers(i) = std(pers);
end

mfrq = 1./mpers;
mfrq(isnan(mfrq))=0;

end