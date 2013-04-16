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
% Started by Sergey Stavisky on 15 October 2011
% Completed by YOU on ____
function axh = drawRasters( axh, spikeTimes, xlim, verticalOffset )
    % ******************************************************************
    %                    Parameter Check
    % ******************************************************************

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
    %
    % HINT: You need to decide how many y-axis units tall to make each line. In one sense 
    % it doesn't matter, since even a tiny vertical line will be visible, but if it is small
    % the rasters will be hard to read. The size of each vertical line 
    % also determine how large the raster part of the plot is compared to the PSTH.
    % Making each spike vertical line 5 units tall is what I chose to use for the sample figure 
    % you've been provided.
    numTrials = numel( spikeTimes );
    
    for iTrial = 1 : numTrials
        
        %
        %
        %
        % [ BLOCK OFYOUR CODE HERE ]
        %
        %
        %
        %
        
    end %for iTrial = 1 : numTrials
    


    % Set horizontal axis limits based on input xlim.
    % [ YOUR CODE HERE ]
    % Set the vertical axis limits to go from zero to
    % verticalOffset + (space taken up by your rasters; this depends on their height)
    % [ YOUR CODE HERE ]
    
    % Add the absicssa (x-axis) label: 'Time (ms)'. Because you've already
    % set a number of properties of axh, MATLAB knows that this is your 
    % currently 'selected' axis, so just calling xlabel without specifying 
    % a parent will actually work, but it's good to always include the axis 
    % handle either as the first argument or as the 'Parent' property to be safe.
    xlabel('Time (ms) ', 'Parent', axh, 'FontSize', 11);

end %function axh = drawRasters( axh, spikeTimes, xlim, verticalOffset )