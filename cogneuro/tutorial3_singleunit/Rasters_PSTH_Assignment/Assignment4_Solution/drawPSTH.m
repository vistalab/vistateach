% drawPSTH.m
%
% Takes a list of spike times for multiple trials and plots a Peristimulus-
% Time Histogram (PSTH) in the specified axis which shows the mean number of
% spikes (averaged across trials) in a given temporal bin.
%
% USAGE:
%  axh = drawPSTH( axh, spikeTimes, xlim, binTime )
%
% INPUTS:
%      axh              Axis handle where to plot the rasters
%      spikeTimes       cell array corresponding to trials, each of which contains
%                       a vector of spike times.
%      xlim             specifies the x axis limits (in same units as the 
%                       spikeTimes are in (typically ms).
%                       maxExpectedBinSpike.
%      binTime          width (in same unit of time as spikeTimes are in)
%                       of the bins. Binning starts at t = xlim(1) and goes
%                       up to t = xlim(2).
%                      
% OUTPUTS:
%      axh             Same as input axis handle.
% Last Edited by Sergey Stavisky on 15 October 2011
function axh = drawPSTH( axh, spikeTimes, xlim, binTime )
    % ******************************************************************
    %                    Parameter Check
    % ******************************************************************

    % Make sure the axis handle exists.
    if ~ishandle( axh )
        error('You did not pass in a valid axis to drawRasters.')
    end
    
    % ******************************************************************
    %                       Bin The Spike Times
    % ******************************************************************
    numTrials = numel( spikeTimes );
    
    % Use the binSpikeTimes function provided (read its header to see how
    % to use it) to get the average number of
    % spikes per bin (averaged across trials). Note that you want to give it
    % a 1 x numTrials cell array of spike times, because the function is 
    % also capable of handling multiple channels (units) of data at once and 
    % so expects the input cell array to be channel x trials.
    [binnedSpikes binStartTimes binEndTimes] = binSpikeTimes( spikeTimes', binTime, xlim(1), xlim(2) );
    
    % Convert to firing rate (Hz) by dividing by the binWidth (so you have spikes
    % per ms) and then multiply by 1000 to get Hz (spikes/second).
    binnedSpikes = (binnedSpikes ./ binTime)*1000;
    
    % You will need to compute the center time of each bin so you can tell the bar( )
    % command where on the x-axis to put each bar. Fortunately, binSpikeTimes.m can return
    % the start and end time of each bin, which you can just average together to get the bin
    % centers.
    binCenters = (binStartTimes + binEndTimes )./2;
   
    % ******************************************************************
    %                        Plot the PSTH 
    % ******************************************************************
    % Don't forget to set hold to be on.
    % Make the bars black. You'll have to look up "Barseries Properties" to 
    % find which property controls bar color; it's not 'Color' as it is with
    % the plot( ) command.
    hold on;
    bar( binCenters, binnedSpikes, 'Parent', axh, 'FaceColor', 'k' );
    
    %Don't forget to label the y-axis
    ylabel('Average Rate (Hz) ', 'FontSize', 11);

end %function drawPSTH