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
% subject was presented either words or scrambled words.

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

%% View a single time series

% While it may not look like there is substantial change in pixel intensity
% over time if we extract the time series from a voxel in the visual cortex
% We can see that there is fluctuation in the signal over time. This is due
% to the blood oxygen level dependent contrast in these images

% Grab the time series from a voxel (x=65, y=45,z=10). The functions
% squeeze puts this data into a vector
ts1 = squeeze(data(65,45,10,:));
% Plot the time series
plot(ts1)

% Questions:
%
% 1. What are the units of the two axes?
% 2. Replot the time series with the x axis labeled in seconds. The 
% function xlabel(' ') will add a label to the axis

%% 
% These are the times when each event started. Each event lasts
% 12 seconds and there is a blank screen in between events. The timing is
% with respect to the fMRI volume number. For example 4 means that the
% event started at during the acquisition of volume number 4.
events_words    = [12 21 41 61 86 95];
events_scramble = [4 32 52 69 77 104];

% Now that we have our event times expressed in terms of scan number we can
% make an ideal time series that would reflect the expected response
% profiles for a voxel that responds to words or scrambled words. We will
% express this as a matrix with 2 columns, column 1 containing the
% predicted time series for words and column 2 containing the predicted time
% series for scrambled words. There will be 114 rows in the matrix because
% there were 114 volumes collected in the fMRI experiment.

% First we allocate a matrix full of zeros
X = zeros(114,2); 
% In the first column denote when words were presented.
X(events_words,1) = 1;
% In the second column denote when scrambled words were presented
X(events_scramble,2) = 1;

% The two mage shows two columns of the design matrix
% The column on the left shows the moment when a volume of the brain is
% collected and a word is presented.  The column on the right shows the
% volumes when a scrambled word was presented.

figure; 
% These are the times when a word (red) or a scrambled word (blue) are
% presented
subplot(2,1,1)
plot(X(:,1),'-r'); hold on
plot(X(:,2),'-b')
legend('words', 'scramble')
xlabel('Volume Number'); ylabel('Signal')

% The times for the words and scrambled words are marked in the two columns
% of this image.  The two columns form a matrix, X, called the design
% matrix.
subplot(2,1,2)
imagesc(X); 
colormap('gray'); ylabel('Volume Number'); 
set(gca, 'xtick',[1 2],'xticklabel', {'words' 'scramble'});


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
figure; plot(hrf); xlabel('Scans (2 seconds)');

% Question:
%
% 3. What does this HRF suggest about the type of cognitive questions that
% can be adressed with fMRI? For example would it be feasible to measure
% precise timing differences in the neural response to different types of
% stimuli? Based on this HRF give a few examples of questions that are and
% are not appropriate to adress with fMRI.

% We can incorporate the knowlege of this hemodynamic response function
% into our design matrix by "convolving" each event with the hrf. This
% means that rather than being represented by a brief spike, the regressors
% are now smoothed in time to match the typical hemodynamic response
X(:,1) = conv(X(:,1), hrf, 'same');
X(:,2) = conv(X(:,2), hrf, 'same');

% Now notice that the events in the design matrix are smoothed in time
% reflecting the predicted hrf.
figure; 
subplot(2,1,1)
plot(X(:,1),'-r'); hold on
plot(X(:,2),'-b')
legend('words', 'scramble')

subplot(2,1,2)
imagesc(X); colormap('gray'); ylabel('Volume Number'); 
set(gca, 'xtick',[1 2],'xticklabel', {'word' 'scramble'});


%% Fitting the linear model to the time series

% There is one more step before we fit a linear model to predict our
% measured BOLD signal based on the regressors we created around our
% experimental design. The units of the measured signal are arbitrary. We
% are interested in predicting changes in the signal over time but we do
% not care about the mean value of the time series. There are 2 ways to
% deal with this. Either subtract the mean from the signal, or add a column
% of ones to the design matrix before fitting the linear model. These two
% aproaches are equivalent

% Jason - demeaning like this is different from the usual detrending.  The
% latter means pulling out the low frequency approximation.  Not sure it
% matters.
ts1_demeaned = ts1 - mean(ts1);

% We can now fit our linear model in which we scale each column of the
% design matrix to best fit our measured signal. 
[B, B_ci] = regress(ts1_demeaned, X);

% The values in B are our beta weights. As with any regression analysis
% these are the weights that scale our regressors to best predict the
% signal. We can now plot our predicted signal agains our measured signal
ts1_predicted = X*B;
figure; hold
plot(ts1_predicted,'-r')
plot(ts1_demeaned,'-b')

% Now we can loop over all the voxels in this slice (z=10) and fit this model to
% each voxel

% First loop over the first dimension (the rows)
for ii = 1:size(data,1)
    % For each row we will now loop over the columns in that row
    for jj = 1:size(data,2)
        % Pull out the time series for the voxel in row number ii of column
        % number jj in slice number 10
        ts = squeeze(data(ii,jj,10,:));
        % demean this time series
        ts_demeaned = ts - mean(ts);
        % Then fit our linear model 
        B = regress(ts_demeaned,X);
        % Now lets take the beta weight for words and put it into a matrix
        % and the weight for scrambled words and put it into another matrix
        B_words(ii,jj) = B(1);
        B_scramble(ii,jj) = B(2);
        % Calculate the model prediction for this voxel
        yhat = X*B;
        % Calculate R squared (R2) the percent of variance explained by the
        % model for this voxel
        R2(ii,jj) = calculateR2(ts_demeaned, yhat);
    end
end

% We can now visualize the beta weights as an image
figure;
imagesc(B_words);
% Add a colorbar
colorbar
% Scale the axis of the color bar to be from 0 to 150
caxis([0 150]);
% Visualize the weights for the scrambled condition
figure;
imagesc(B_scramble); colorbar; caxis([0 150]);

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


% Typically it is nicer to look at an activation map overlaid over a high
% resolution anatomical image. Lets load up a high resolution anatomical
% that is in register with this fmri data
inplane = niftiRead('Inplane.nii.gz');


