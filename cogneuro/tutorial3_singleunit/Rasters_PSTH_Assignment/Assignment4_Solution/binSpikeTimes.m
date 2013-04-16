% binSpikeTimes.m
%
% Takes a list of spike times for one or more channels, from one or more
% trials, and returns a matrix of binned spike counts for each channel, summed
% across trials.
% NOTE: This function does not enforce units (e.g. ms or seconds) so it is 
% up to the caller to verify that all arguments are in the same unit.
% NOTE 2: if (endT-startT) does not divide evenly by binT, then the last bin
% will be cut off (i.e. shorter than binT).
%
% USAGE:
%  binnedMat = binSpikeTimes( spikeTimes, binT, startT, endT )
%
% INPUTS:
%      spikeTimes    cell array containing vectors of spike times. 
%                    Should be chans x trials
%      binT          time width of the bins.
%      startT        start time of first bin.
%      endT          end time of last bin
% OUTPUTS:
%      binnedMat     chan x bin matrix containing the number of spikes
%                    (averaged over trials) for a given channel and time bin.
%      binStarts     start time of each bin
%      binEnds       end time of each bin
% Created by Sergey Stavisky on 11 October 2011
% Last Edited by Sergey Stavisky on 15 October 2011
function [binnedMat binStarts binEnds] = binSpikeTimes( spikeTimes, binT, startT, endT )
    numChans = size( spikeTimes, 1);
    numTrials = size( spikeTimes, 2 );
    
    % Define bin start and end times.
    binStarts = startT : binT : endT-binT;
    binEnds = binStarts + binT;
    numBins = length( binStarts );
    
    % Preallocate output array binnedMat
    binnedMat = zeros( numChans, numBins );
    
    % Loop across bins and sum spikes that fall within this bin
    for iBin = 1 : numBins
        sumSpikes = cellfun( @(i) nnz( (i >= binStarts(iBin)) & (i < binEnds(iBin)) ), spikeTimes ); % Advanced shortcut here; don't worry about it
        binnedMat(:,iBin) = sum( sumSpikes,2 );        
    end %for iBin = 1 : numBins
    
    % Divide by number of trials to get average number of spikes/bin/trial
    binnedMat = binnedMat ./ numTrials;

end %function binnedMat

