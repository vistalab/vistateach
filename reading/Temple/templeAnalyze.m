% Analyze the Temple data and the value of the outlier
%
% chdir('C:\u\brian\Matlab\VISTATEACH\Teaching\Reading\Temple')

% Read in the data from the figure and plot them
d = load('Figure2Data.txt ');
figure(1);
plot(d(:,1),d(:,2),'o');
axis equal
grid on

% Elise reports a value of 0.41.  We estimate a value of 0.43.  Pretty good
% agreement given that I read the data with DataThief.
% This corrcoef explains about 15% of the variance in the measurements
% 
% corrcoef(d)

% Now, we have these two weird data points.  There are two individuals who
% had zero change in their language score, but a large negative change in
% their BOLD response.  What can that mean?  How does it relate to the
% experimental predicts that the training influences reading?

% So, we ask, what is left if we remove these two individuals
l = find(d(:,2) > 15);
dClipped = d(l,:);
figure(1);
plot(dClipped(:,1),dClipped(:,2),'o');
axis equal
grid on

% Now, the power is only 7-9 percent of the variance
%
% corrcoef(dClipped)

% We can check whether this is reliably different by bootstraping the data
% Let's compoare the data with the outliers removed and the full set.
%
data = dClipped;

N = 1000;
clear c
c = zeros(1,N);
nData = length(data);
for ii=1:N
    s = rand(1,nData);
    s = floor(s*nData) + 1;         % From 0 to nData - 1, then add 1
    tmp = data(s,:);
    tmp = corrcoef(tmp);
    c(ii) = tmp(1,2);
end
subplot(1,3,1);
hist(c,50);  grid on
fprintf('Clipped: %.3f\n',median(c))
xlabel('Corr coef'); ylabel('N samples'); title('Outliers removed')

% Now the full set
data = d;
N = 1000;
clear c
c = zeros(1,N);
nData = length(data);
for ii=1:N
    s = rand(1,nData);
    s = floor(s*nData) + 1;         % From 0 to nData - 1, then add 1
    tmp = data(s,:);
    tmp = corrcoef(tmp);
    c(ii) = tmp(1,2);
end
subplot(1,3,2); 
hist(c,50); grid on
fprintf('Full: %.3f\n',median(c))
xlabel('Corr coef'); ylabel('N samples'); title('Full')

% Now re-sample with only 16 points
data = d;
N = 1000;
clear c
c = zeros(1,N);
nData = length(data);
for ii=1:N
    s = rand(1,nData-2);
    s = floor(s*nData) + 1;         % From 0 to nData - 1, then add 1
    tmp = data(s,:);
    tmp = corrcoef(tmp);
    c(ii) = tmp(1,2);
end
subplot(1,3,3)
hist(c,50);  grid on
fprintf('Subsampled: %.3f\n',median(c))
xlabel('Corr coef'); ylabel('N samples'); title('Subsampled - 2')