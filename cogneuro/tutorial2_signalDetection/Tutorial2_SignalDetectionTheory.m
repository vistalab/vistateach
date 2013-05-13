%% Psychophysics and Signal Detection Theory tutorial
%
%
% Written by G.M. Boynton for CSHL June, 2012
% Modified by Jason D. Yeatman and Brian A. Wandell for Stanford Cognitive
% Neuroscience core course, April 2013

%% Signal Detection Theory
%
% Suppose you want to determine if a subject can reliably detect a weak
% stimulus.  The simplest experiment would be to present this stimulus over
% multiple trials and ask if the subject saw it.  But this won't work
% because, for example, the subject could simply say 'yes'on each trial.
% To improve the experimental design, 'no stimulus' trials (catch trials)
% should be included. 
%
% Now suppose you introduce catch trials (no stimulus trials) randomly on
% half of the trials.  The subject's task is to determine if the signal is
% present on any given trial.  Stimulus present trials are called 'signal'
% trials, and no stimulus trials are called 'noise' trials. A subject
% that guesses, or says 'yes' or 'no' on every trial will be perform at
% 50%, or chance level.  
%
% There is a range of stimulus intensities where a subject will perform
% somewhere between chance and 100% correct performance.  The presence of
% such a 'soft' threshold is most commonly explained in terms of Signal
% Detection Theory (SDT).
%
% SDT assumes that subjects base their decision on an internal response to
% a stimulus and that response varies trom trial to trial.  If this
% internal response exceeds some criterion, the subject reports to have
% perceived the stimulus. If the internal response is below this criterion
% than the subject will report that no stimulus was present.
%
% This trial-to-trial variability of the internal response could be due to
% variability in the stimulus itself (as in the case of Poisson noise for
% very dim lights), or to random neuronal noise at the sensory
% representation of the stimulus, or due to higher level variability in the
% attentional or motivational state of the subject.  
%
% Most commonly, this variability is modeled as a norrmal distribution
% centered around some mean. The simplest implementation of this model sets
% the mean response for the noise trials to zero and signal trials some
% larger value, with the standard deviations of the signal and noise
% responses the same.

%% Initializing the parameters

% Here are some example parameters. Considder these to represent the
% distribution of internal responses to the signal and noise conditions

noiseMean = 0;   
signalMean = 1;
sd = 1;

%% Plot the signal and noise distributions
%
% Here is a graph of the probability distribution for the internal
% responses to signal and noise trials:

% We will calculate the height of each probability distribution at these
% points
z = -4:.2:6;  

noise_y  = normalpdf(z,noiseMean,sd);
signal_y = normalpdf(z,signalMean,sd);

newGraphWin;
clf
plot(z,noise_y);
hold on
plot(z,signal_y,'r-');

ylim = get(gca,'YLim');

text(noiseMean,ylim(2)*.9,'Noise','VerticalAlignment','top','HorizontalAlignment','center','Color','b');
text(signalMean,ylim(2)*.9,'Signal','VerticalAlignment','top','HorizontalAlignment','center','Color','r');
xlabel('Internal Response');

% We next need to set a criterion value for determining what internal
% reponses lead to 'Yes' responses.  

criterion = 1.5;
plot(criterion*[1,1],ylim,'k:');

hcrit = text(criterion,0,'criterion','VerticalAlignment','bottom','HorizontalAlignment','left');

%% Hits and false alarms: The basics of signal detection theory
%
% On any trial, one of four things will happen. Either the signal is
% present or absent crossed with the subject reporting 'yes' or 'no'.
% Trial types are labeled this way:
%
%           |         Response     |
%  Signal   |  "Yes"    |  "No"    |
%  ---------------------------------
%  Present  |    Hit    |  Miss    |
%           |           |          |
%  ---------+-----------+----------|
%  Absent   |  False    | Correct  |
%           |  Alarm    | Rejection|
%  ---------------------------------
%
% It's easy to see that SDT predicts the probability of each of these four
% trial types by areas under the normal curve.  The probability of a hit
% is calculated based on the area under the probability density function
% representing internal responses to the signal that exceed the criterion.

pHit = 1-normalcdf(criterion,signalMean,sd)

% And the probability of a false alarm is calculated by integrating the
% area under the function representing interal responses to noise that are
% below the criterion.

pFA =  1-normalcdf(criterion,noiseMean,sd)

% Questions:
%
% 1. Calculate the probability of a miss (fill in the computations below)
pMiss =
% 2. Calculate the probability of correct rejection.
pCR = 

% The whole table looks like this:
disp(' ');
disp('           |         Response     |')
disp('  Signal   |  "Yes"    |  "No"    |')
disp('  ---------------------------------')
fprintf('  Present  |   %3.1f%%   |   %3.1f   |\n',100*pHit,100*pMiss);
disp('  ---------+-----------+----------|');
fprintf('  Absent   |   %3.1f    |   %3.1f   |\n',100*pFA,100*pCR);
disp('  ---------------------------------');

%%
% Since half the trials are signal trials, the overall performance will be
% the average of the hit and correction rate:

PC = (pHit + pCR)/2;  %proportion correct
fprintf('  Percent Correct: %5.2f%%\n',100*PC);

%% Questions about the parameters
%
% Play around with the parameters. See how:
%
% 3) If you shift your criterion very low or high what will happen to
% performance?
%
% 4) Performance (in terms of percent correct) is maximized when the
% criterion is halfway between the signal and noise means.  Assuming that
% the payoff for a hit is equal to the punishment for a false alarm for
% this is the criterion an "ideal observer" should choose. As an
% experimenter how might you get your subject to increase or decrease their
% criterion?
%
% 5) Based on the distribution of internal responses to signal and noise
% trials there are 2 ways to effect performance. Please describe how
% adjusting the parameters of the distributions will affect the performance
% of a subject.


%% D-prime:  The separation between noise and signal plus noise
%
% The goal of a psychophysicist is to learn something about the internal
% response to a stimulus based on a behavioral responses.  In SDT terms,
% we want to know the strength of the internal response to the signal
% relative to the noise.  Formally, this is defined as the difference
% between the signal and noise means in standard deviation units and is
% called d-prime:

dPrime = (signalMean-noiseMean)/sd;
fprintf(sprintf('  dPrime =    %5.2f\n',dPrime));

%% Estimating d-prime from Hits and False Alarms
%
% You should see that simply reporting percent correct in a yes/no
% experiment is a problem because performance varies with criterion: you
% cannot estimate d-prime from percent correct alone.
%
% But fortunately we can estimate d-prime by finding the difference in the
% corresponding z-values from the hit and false alarm rates:

zHit = normalinv(pHit)
zFA  = normalinv(pFA)

dPrimeEst = zHit-zFA

% Questions
%
% 6. Play again with the parameters.  Does dPrimeEst stay constant for
% different criterion values? Report 4 criterion values and the associated
% dPrime values. Can you explain this pattern of results?


%% The receiver operating characteristic (ROC) curve
%
% The criterion determines the trade-off between hits and false alarms.  A
% low (liberal) criterion is sure to get a hit but will lead to lots of
% false alarms. A high (conservative) criterion will miss a lot of signals,
% but will also minimize false alarms.  This trade-off is typically
% visualized in the form of a 'Reciever Operating Characteristic' or ROC
% curve.  An ROC curve is a plot of hits against false alarms for a range
% of criterion values:

pHits = 1-normalcdf(z,signalMean,sd);
pFAs  = 1-normalcdf(z,noiseMean,sd);
newGraphWin;

hold on
plot([0,1],[0,1],'k:');
axis equal
axis tight
xlabel('pFA');
ylabel('pHit');
plot(pFAs,pHits,'k-');

% We can plot a point on this ROC curver corresponding to our hit rate
% and false rate from the above example.
plot(pFA,pHit,'ko','MarkerFaceColor','w');

% Questions about the ROC:
%
% 7. Add points to this ROC curve marking the hit and false alarm rates for
% the 4 different criterion values you tried in question 6.
%
% 8) Plot 4 ROC curves where you increase/decrease the standard deviation
% and increase/decrease the signal strength. How does the box of the ROC
% curve change in these 4 examples and how does this relate to d-prime.

%% Being right:  The area under the ROC curve
%
% You hopefully saw that changing d-prime increases affects the bow of the
% ROC curve away from the diagonal.  A measure of this bowing is the area
% under the ROC curve.  This can be estimated by numerically integrating
% the sampled curve.  We'll use Matlab's 'trapz' function. (The negative
% sign is to undo the fact that the ROC curve traces from left-to-right for
% increasing criterion values).

ROCarea = -trapz(pFAs,pHits)

% We can demonstrate that this area has a special meaning - it's the percent
% correct that is expected in a two-alternative forced choice (2AFC)
% experiment.


%% The relationship between d-prime and the area under the ROC curve

% d-prime can be calculated from the area under the ROC curve by:

dPrimeFromArea = sqrt(2)*normalinv(ROCarea)

% The calculus behind this is interesting but we'll pass on it. 

%% Simulating a Yes/No experiment
%
% Next we'll use SDT to simulate a subject's response to a series of trials
% in a Yes/No experiment and estimate the d-prime value that was used in
% the simulation

nTrials = 100;
isSignal = logical(floor(rand(1,nTrials)+.5));  %coin flip for each trial

% Generate the internal response for each trial
x = randn(1,nTrials)*sd;  %draws from normal distribution with standard deviation sd.
x(isSignal) = x(isSignal) + signalMean; 
x(~isSignal) = x(~isSignal) + noiseMean;

% Subject responds '1' if the internal response exceeds the criterion.
response = x>criterion;

% Calculate hits and false alarms
pHitSim = sum(response(isSignal))/sum(isSignal);
pFASim = sum(response(~isSignal))/sum(~isSignal);

% Show the simulated values in the table
disp(' ');
fprintf('Simulation of %d trials:\n',nTrials);
disp('           |       Response        |')
disp('  Signal   |  "Yes"    |  "No"     |')
disp('  ---------------------------------')
fprintf('  Present  |   %3.1f%%   |   %3.1f%%   |\n',100*pHitSim,100*(1-pHitSim));
disp('  ---------+-----------+-----------|');
fprintf('  Absent   |   %3.1f%%    |   %3.1f%%   |\n',100*pFASim,100*(1-pFASim));
disp('  ---------------------------------');

% plot it on the ROC curve

hROC = plot(pFASim,pHitSim,'bo','MarkerFaceColor','w');

% calculating d-prime from pHit and pCR
zHitSim = normalinv(pHitSim);
zFASim = normalinv(pFASim);

dPrimeSim = zHitSim-zFASim;
fprintf('d-prime from simulation = %5.2f\n',dPrimeSim);

%% Questions about reliability and experimental design. 
%
% Compare the simulated values to the expected values from the STD model.
% You can run this section over and over to look at the variability of the
% d-prime estimate. You can see that:
%
% 9. How does the number of trials affect our estimates of d-prime? 
%
% 10. Does the criterion value effect our ability to estimate d-prime? How
% does the variability of d-prime estimates change when there is a very
% high or very low criterion? What does this tell us about the ideal design
% of a psychophysics experiment (assuming our goal is to estimate d-prime)
%
% Extra Credit) If you're motivated, add a loop to simulate a bunch of
% simulations to estimate the variability in the estimate for a range of
% model parameters.
%
% Simulations like this illustrate an often neglected fact:  A 'perfect'
% subject that makes decisions according to Signal Detection Theory will
% still have variability in performance from experimental run to
% experimental run.  That is, ideal observers will still generate data with
% finite-sized error bars.  Simulations can give you a feel for how small
% the erorr bars should be under ideal conditions.
%
% 11. Beyond classic pychophysics investigations of sensory systems briefly
% (1-2 paragraphs) discuss how signal detection theory has been used in
% another area of psychology. There are many examples but this might
% require a bit of outside research.

%% End

