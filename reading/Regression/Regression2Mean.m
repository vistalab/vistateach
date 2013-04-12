%
% Regression2Mean
%
% Author: Wandell (Hum Bio 153)
% Purpose:
%   Illustrate regression to the mean when testing a group twice.
%

% We have 100 students with abilities from 0 to 1.  We list them in rank
% order.
N = 100;
ability = [1:N]/N;

% An ideal test would have a noise-free measurement instruement
testScore = 100*ability;

plot(ability,testScore);
xlabel('Ability'); ylabel('Noise free test');
grid on

% No test is noise free.  So, suppose that the noise is Gaussian and has a
% standard deviation of 15.
noise1 = randn(size(testScore))*15;
measurement1 = testScore + noise1;

plot(ability,measurement1,'o');
xlabel('Ability'); ylabel('Typical test (std 15)');
grid on

% Now, let's find the low-scoring individuals
% Since the std dev is 15, and the mean is 50, let's just find the ones
% that are 2 sd below the mean.
lowScoringList = find(measurement1 < 20);

% Notice that this is not precisely the first 20.  There was some bad luck
lowScoringList

% Show them on a graph
plot(ability,measurement1,'o',ability(lowScoringList),measurement1(lowScoringList),'ro');
xlabel('Ability'); ylabel('Typically test:  std 15');
grid on

% The mean score for these kids is
mean(measurement1(lowScoringList))

% While the mean for the whole group is
mean(measurement1)

% Now, let's retest these kids
noise2 = randn(size(testScore))*15;
measurement2 = testScore + noise2;

% How about test reliability?
plot(measurement1, measurement2, 'o');
xlabel('Test 1'); ylabel('Test 2');
grid on
corrcoef([measurement1(:),measurement2(:)])

plot(ability,measurement2,'o',ability(lowScoringList),measurement2(lowScoringList),'ro');
xlabel('Ability'); ylabel('Typically test:  std 15');
grid on

subplot(1,2,1); hist(noise1(lowScoringList), 10); grid on; set(gca,'xlim',[-40 40],'ylim',[0,6],'ytick',[0:2:6])
subplot(1,2,2); hist(noise2(lowScoringList), 10); grid on; set(gca,'xlim',[-40 40],'ylim',[0,6],'ytick',[0:2:6])


% How did our kids do on the retest?
mean(measurement2(lowScoringList))
mean(measurement2)


