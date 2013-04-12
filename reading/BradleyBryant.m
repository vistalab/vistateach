% Data from Table 2.  Oddity paradigm

expErrors = [1.15, 1.49, 2.62]; eSE = [1.43, 1.58, 2.26]/sqrt(60);
conErrors = [0.17, 0.37, 0.67]; cSE = [1.11, 0.99, 1.188]/sqrt(30);

p1 = errorbar(1:3,expErrors,eSE); hold on;
set(p1,'linewidth',2);
p2 = errorbar(1:3,conErrors,cSE,'r'); hold off
set(p2,'linewidth',2);
grid on

set(gca,'xtick',[1:3],'xticklabel',{'1st','2nd','3rd'});
ylabel('Number of errors');
xlabel('Phoneme position');

% Rhyming data
n = 0:10;
expFailures = [37, 4, 4, 4, 2, 2, 2, 2, 0, 0, 3];
conFailures = [28, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0];
clf
p = plot(n,1 - cumsum(expFailures)/60,'b-',n,1 - cumsum(conFailures)/30,'r-')
set(p,'linewidth',2);

xlabel('Number of words');
ylabel('Prob of failing to rhyme');
grid on
set(gca,'ylim',[-.02 0.5],'ytick',[0:.1:5])
set(gca,'xtick',[0:2:10]);
