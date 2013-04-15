%% fMRI time series
%
% Teaching objectives:
% 
% 1. Get a feeling for time series data collected in an fMRI experiment.
% What does the signal look like, how does it vary, how large is the signal
% change, how noisy etc.
%
% 2. Learn the about hemodynamic responses
%
% 3. Understand the basics of how fMRI data is analyzed using a linear
% model.
%
% 4. By the end of this tutorial each student should understand the basic
% steps that take raw fMRI data to the figures of a heatmap on the brain
% that you see in papers
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load and visualize the data
% In an fMRI experiment sequential brain volumes are collected while the
% stimuli and task are manipulatd. Each brain volume is a 3 dimensional
% image and each pixel in the image is called a voxel. Here is a video of a
% single slice of the brain over the course of an fMRI experiment where the
% subject was presented either words or scrambled words. Brain volumes were
% collected every 2 seconds (TR = 2seconds).

% The data is saved in the same folder as the tutorial
load data

% Open a figure window
figure; colormap('gray')
% Make a movie of slice number 10
for ii = 1:size(data,4)
    % Show the image of this slice during volume number ii
    imagesc(squeeze(data(:,:,10,ii))); 
    % pause for .2 seconds
    drawnow; pause(.1);
end

%% View the time series from a single voxel

% While it may not look like there is substantial change in pixel intensity
% over time if we extract the time series from a voxel in the visual cortex
% We can see that there is fluctuation in the signal over time. This is due
% to the blood oxygen level dependent (BOLD) contrast in these images

% Extract the time series from a voxel (x=65, y=53,z=10). 
% (The function squeeze converts the 4D data, (x,y,z,time) into a vector)
ts1 = squeeze(data(65,53,10,:));

% This is the number of brain volumes at the repetition rate (TR)
nTR = size(data,4);   

% Plot the time series for this single voxel.
figure; 
plot(1:nTR, ts1)
xlabel('TR')
ylabel('Scanner digital value')
title('Voxel 65,53,10 time series')

% Questions:
%
% 1. What are the units of the two axes?
% 2. Find 1 voxel where the signal varies more over time and another voxel
% where the signal varies less over time. Plot each voxel's time series and
% title the figure apropriately. Save these as pdfs and turn them in.

%% Associate the time series with the stimuli
% These are the times when each event started. Each event lasts 12 seconds
% and there is a blank screen in between events. The timing is with respect
% to the fMRI volume number. For example 4 means that the event started at
% during the acquisition of volume number 4 (which is 8 seconds into the
% experiment because volumes are collected every 2 seconds. We mark each
% volume during which the event occured meaning that there are a block of
% six volumes devoted to each occurance of the stimulus

events_words    = [12:17 21:26 41:46 61:66 86:91 95:100];
events_scramble = [4:9 32:37 52:57 69:74 77:82 104:109];

% Now that we have our event times expressed in terms of scan number we can
% make an ideal time series that would reflect the expected response
% profiles for a voxel that responds to words or scrambled words. We will
% express this as a matrix with 2 columns, column 1 containing the
% predicted time series for words and column 2 containing the predicted time
% series for scrambled words. There will be 114 rows in the matrix because
% there were 114 volumes collected in the fMRI experiment. This is called
% the design matrix because it denotes the experimental design.

% First we allocate a 114x2 matrix full of zeros
X = zeros(114,2); 
% In the first column denote when words were presented by putting a 1 in
% each location where the word stimulus was on
X(events_words,1) = 1;
% In the second column denote when scrambled words were presented
X(events_scramble,2) = 1;

% The image shows two columns of the design matrix

figure; 
% These are the times when a word (red) or a scrambled word (blue) are
% presented. The subplot command allows you to put multiple plots in a
% figure window
subplot(2,1,1)
plot(X(:,1),'-r'); hold on
plot(X(:,2),'-b')
legend('words', 'scramble')
xlabel('Volume Number'); ylabel('Signal')

% The times for the words and scrambled words are marked in the two columns
% of this image.  The two columns form a matrix, X, called the design
% matrix. One column shows the moment when a volume of the
% brain is collected and a word is presented.  The other
% shows the volumes when a scrambled word was presented.

subplot(2,1,2)
% The ' symbol transposes the matrix X. We are only doing this so that the
% 2 plots have a common x axis. After transposing the design matrix the x
% axis is time  and the y axis is condition rather than vice versa. 
imagesc(X'); 
colormap('gray'); xlabel('Volume Number'); 
set(gca, 'ytick',[1 2],'yticklabel', {'words' 'scramble'});


%% Analyze the time series

% There is one problem with this model of the time series. When a neural
% event occurs it does not cause a rapid peak in the BOLD signal, but
% instead there is a slow response that evolves over time
%
% We know roughly how the vascular response measured by BOLD evolves over
% time. This means that when there is an event that stimulates a brief neural
% response (say a flash of light), the resulting BOLD signal will change in
% a characteristic way. We call this the hemodynamic response function (HRF). 

% Load up a typical hemodynamic response function and plot it
load hrf.mat
figure; 
plot(hrf); xlabel('Scans (2 seconds)');

% Question:
%
% 3. What does this HRF suggest about the type of cognitive questions that
% can be adressed with fMRI? For example would it be feasible to measure
% precise timing differences in the neural response to different types of
% stimuli? Based on this HRF give a few examples of questions that are and
% are not appropriate to adress with fMRI.

%% Convert the raw scanner numbers to a percent contrast

% The digital values coming from the scanner have no physical significance.
% digital values from some regions are a little higher than others for
% instrumental reasons, say because the measurement coil is more sensitive
% to the surface of the brain than the middle.  Other uninteresting reasons
% also give rise to these differences.
%
% It is common, therefore, to express the time series as a percent
% modulation around the mean signal. This moves us towards comparing more
% similar variations - though even this move is not really enough.

meanTS = mean(ts1(:));
ts1 = 100* ((ts1 - meanTS)/ meanTS);

% Plot the modulation
figure; 
plot(1:nTR,ts1)
xlabel('TR')
ylabel('Percent modulation of BOLD signal')
grid on


%% Convolving the design matrix with the HRF (sorry for the jargon)
%
% We can incorporate the knowlege of this hemodynamic response function
% into our design matrix by "convolving" each event with the hrf. This
% means that rather than being represented by a brief spike, the regressors
% are now smoothed in time to match the typical hemodynamic response. It is
% not important that you understand this specific code, just the idea that
% each event is multiplied or convolved with the known hemodynamic response
% function (HRF)

tmp = conv(X(:,1),hrf); X(:,1) = tmp(1:length(X(:,1)));
tmp = conv(X(:,2),hrf); X(:,2) = tmp(1:length(X(:,2)));

% Now notice that the events in the design matrix are smoothed in time
% reflecting the predicted hrf.
figure; 

% Plot the new predicted time series after convolution
subplot(2,1,1)
plot(X(:,1),'-r'); hold on
plot(X(:,2),'-b')
legend('words', 'scramble')
% Show an image of the new design matrix
subplot(2,1,2)
imagesc(X'); colormap('gray'); xlabel('Volume Number'); 
set(gca, 'ytick',[1 2],'yticklabel', {'word' 'scramble'});


%% Fitting the linear model to the time series

% In fMRI a linear model is used to estimate how much each event type
% effects the measured BOLD signal. Another way to say this is that we want
% to find the best way to scale our predictor matrix X to match our
% measured signal. The scaling factor or weights for each condition are
% related to the amount of BOLD signal modulation produced by that event.
% Let's look at our predictors compare to our measured signal in this
% voxel.
figure; 
subplot(2,1,1)
plot(1:nTR,ts1)
subplot(2,1,2)
plot(X(:,1),'-r'); hold on
plot(X(:,2),'-b')
legend('words', 'scramble')

% There is one more step before we fit a linear model to predict our
% measured BOLD signal based on the regressors we created around our
% experimental design. As we said above the units of the measured signal
% are arbitrary. We are interested in predicting changes in the signal over
% time but we do not care about the mean value of the time series or other
% aribtrary factors related to the scanner. To deal with this we include
% regressors in the design matrix to deal with nuisance factors such as the
% arbitraryness of the units and slow drift in signal intensity due to
% imperfections in the instrament. These are often referred to as nuisance
% regressors. Most researchers will include a column of ones to deal with
% the offset and a linear term to deal with scanner drift.
X = horzcat(X, ones(size(X,1),1), linspace(-1,1,size(X,1))');
% Here is our new design matrix
figure; imagesc(X);

% We fit a linear model in which we scale each column of the
% design matrix to best fit our measured signal.
% Usually a linear model means you have a vector you wish to predict, in
% this case the time series, as the weighted sum of other vectors in the
% columns of a matrix, in this case the design matrix.  The weights are
% often called 'beta' weights when we analyze fMRI data. Here is the
% equation for the linear model
%
%    ts1 = X * betaWeights
%
% Matlab solves these problems with the very simple formula
B = X\ts1;

% This is the same as
%   B = regress(ts1_demeaned, X);
% if you have the statistics toolbox
%
% The point to take away is that fitting a linear model to fMRI data is no
% different than any regression probelm. We set up a matrix of predictor
% variables and use any regression function to find weights that predict
% our measurement as a weighted sum of our regressors.

% These are the 'beta' weights for the (1) word and (2) scrambled word
% events, along with the weights on our nuisance variables.
B

%% Comparing the solution with the true data

% The values in B are our beta weights. As with any regression analysis
% these are the weights that scale our regressors to best predict the
% signal. We can now plot our predicted signal agains our measured signal
ts1_predicted = X*B;
figure; hold
plot(ts1_predicted,'-r')
plot(ts1,'-b')


%% Calculate the beta values for the whole slice
% Now we can loop over all the voxels in this slice (z=10) and fit this
% model to each voxel. Even if this code doesn't make sense try to
% apreciate the fact that we are fitting this same regression equation to
% every voxel in this image. What we obtain is a set of 'beta' weights for
% each voxel in the image. The resulting beta weight images show locations
% where a given condition effects the BOLD signal

% Allocate space
B_words    = zeros(size(data,1),size(data,2));
B_scramble = zeros(size(data,1),size(data,2));
R2         = zeros(size(data,1),size(data,2));

% First loop over the first dimension of this slice (the rows)
for ii = 1:size(data,1)
    % For each row we will now loop over the columns in that row
    for jj = 1:size(data,2)
        % Pull out the time series for the voxel in row number ii of column
        % number jj in slice number 10
        ts = squeeze(data(ii,jj,10,:));
        % demean this time series
        ts_demeaned = ts - mean(ts);
        % Then fit our linear model 
        B = X\ts_demeaned;
        % Now lets take the beta weight for words and put it into a matrix
        % and the weight for scrambled words and put it into another matrix
        B_words(ii,jj) = B(1);
        B_scramble(ii,jj) = B(2);
    end
end

%% We can now visualize the beta weights as an image
% This image shows how much each condition effected the BOLD signal in each
% voxel of the image. Hence this map retains the same orientation as our
% original data
figure;
imagesc(B_words);
% Label the demensions of the axes
xlabel ('Anterior <--> Posterior'); ylabel('Left <--> Right');
% Add a colorbar
colorbar
% Scale the axis of the color bar to be from 0 to 30. This is roughly the
% range of our beta weights
caxis([0 30]);
% Visualize the weights for the scrambled condition
figure;
imagesc(B_scramble); colorbar; caxis([0 30]);

% Questions
%
% 4. What are the units of the color map?
%
% 5. What can we learn from looking at these color maps? Does the pattern
% of responses make sense (on the scale of brain lobe)? Why or why not?
%
% 6. One of the typical ways neuroscientists localize a brain region that
% responds more to one stimulus class compare to another is by making a
% subtraction image that compares the weights obtained for each condition.
% Make a subtraction image and find a voxel (x,y,z coordinates) that
% responds more to words than scrambled words. Hint: in the matlab figure
% window if you click on the icon with a plus sign on it it will allow you
% to click on image pixels and get the x and y coordinates. You already
% know the z coordinate (that is the slice number).

%% Overlay the heatmap on a high resolution anatomical image
% Typically it is nicer to look at an activation map overlaid over a high
% resolution anatomical image. Lets load up a high resolution anatomical
% that is in register with this fmri data
inplane = niftiRead('Inplane.nii.gz');
% This is what slice 10 of this image looks like. 
figure;imagesc(inplane.data(:,:,10)); colormap('gray');

% To overlay our activation map we must first interpolate it to be the same
% resolution as our anatomy image which is 256x256 pixels
map = imresize(B_words, [256 256]);


