% drawRasters.m
%
% Takes a list of spike times for multiple trials and plots rasters starting
% with the first trial at the top and working down, in the axis specified by
% input argument <axh>. To accomodate other data plotted below the rasters 
% in the same axis (e.g. binned spiked counts/rates) the lowest raster is 
% placed at y-axis location specified by verticalOffset.
%
% USAGE:
%  axh = drawRasters( axh, spikeTimes, xlim, verticalOffset )
%
% INPUTS:
%      axh              Axis handle where to plot the rasters
%      spikeTimes       cell array corresponding to trials, each of which contains
%                       a vector of spike times.
%      xlim             specifies the x axis limits (in same units as the 
%                       spikeTimes are in (typically ms).
%                       maxExpectedBinSpike.
%      verticalOffset   specifies the y location at which to start plotting rasters
%  
%                       
% OUTPUTS:
%      axh             Same as input axis handle.
% Last Edited by Sergey Stavisky on 15 October 2011
function axh = drawRasters( axh, spikeTimes, xlim, verticalOffset )
    % ******************************************************************
    %                    Parameter Check
    % ******************************************************************
    tickHeight = 5;
    
    % Make sure the axis handle exists.
    if ~ishandle( axh )
        error('You did not pass in a valid axis to drawRasters.')
    end
    
    % ******************************************************************
    %              Make vertical lines for each trial's spikeTimes
    % ******************************************************************
    % Use an outer loop across trials, and inner loop that makes a small vertical line for each trial.
    % Note: A better, more advanced way to do this is to replace the inner loop with a 
    % vectorized line call that would draw all the spike lines for a given trial in one
    % command. To do this, you specify multiple lines' coordinates in an input
    % matrix for X and Y. This way of calling line( ) is explained in the function's
    % help page; feel free to try to do it this way if you want an added challenge.
    numTrials = numel( spikeTimes );
    
    for iTrial = 1 : numTrials
        mySpikeTimes = spikeTimes{iTrial};
        
        % determine the vertical start and stop locations for this trial.
        % I'm going to make each spike tick 5 units tall. I want the first trial
        % to go on top, work from top down.
        myY = [verticalOffset + numTrials*tickHeight - tickHeight - tickHeight*iTrial , verticalOffset + numTrials*tickHeight - tickHeight*iTrial];
        
        % Loop across each spike and make a line to mark it. Its x location
        % is the time of the spike. 
        for iSpike = 1 : length( mySpikeTimes )
            line( [mySpikeTimes(iSpike) mySpikeTimes(iSpike)], myY, 'Parent', axh, ...
                'Color','k','LineWidth', 1)
        end %for iSpike = 1 : length( mySpikeTimes ) 
    end %for iTrial = 1 : numTrials
    


    % Set horizontal axis limits based on input xlim.
    set( axh, 'Xlim', xlim );
    % Set the vertical axis limits to go from zero to verticalOffset + numTrials
    set( axh, 'ylim', [0,  verticalOffset + tickHeight*numTrials]);
    
    % Add the absicssa (x-axis) label: 'Time (ms)'. Because you've already
    % set a number of properties of axh, MATLAB knows that this is your 
    % currently 'selected' axis, so just calling xlabel without specifying 
    % a parent will actually work, but it's good to always include the axis 
    % handle either as the first argument or as the 'Parent' property to be safe.
    xlabel('Time (ms) ', 'Parent', axh, 'FontSize', 11)

end %function axh = drawRasters( axh, spikeTimes, xlim, verticalOffset )