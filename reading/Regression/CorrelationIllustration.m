%
% Illustrate correlation coefficient

% Suppose we have 500 students with a range of abilities
N = 500;
ability = [1:N]'/N;

% When we administer a test, there will be noise in the measurement.  The
% st. dev. of the noise is about equal to the size of the ability range.
noise = randn(N,1);

% The test scores will be some weighted combination of the true ability and
% noise
wgt = [0:.15:0.9];
test = zeros(N,length(wgt));
for ii=1:length(wgt)
    test(:,ii) = wgt(ii)*ability + (1-wgt(ii))*noise;
end

% We can calculate the correlation (r value) and the likelihood that the correlation
% is statistically significant (p-value).
r = zeros(1,length(wgt));
p = zeros(1,length(wgt));

figure(1);
for ii=1:length(wgt)
    plot(ability, test(:,ii),'bo');
    set(gca,'xlim',[-0.1 1.2],'ylim',[-0.5 1.5]); grid on
    xlabel('True ability'); ylabel('Test score'); title(sprintf('Weight %.02f\n',wgt(ii)));
    pause
    [c,l] = corrcoef(ability,test(:,ii));
    r(ii) = c(1,2); 
    p(ii) = l(1,2);
end

% We can summarize the relationship between the r and p values for this
% sample size.
figure(2);
semilogy(r,p,'r-'); 
set(gca,'ylim',[1e-6 1])
line([0 1],[.05,.05],'color','k')
xlabel('Corrrelation coefficient (r)');
ylabel('Significance level (p)');