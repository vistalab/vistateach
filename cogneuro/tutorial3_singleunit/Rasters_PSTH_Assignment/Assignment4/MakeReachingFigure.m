% MakeReachingFigure.m
% NENS 230 Autumn 2011, Stanford University
%
% Given a filename containing properly formatted data of spike times
% from multiple trials of reaching to various targets, will create a nicely
% laid out figure with a different subplot showing the data for reaches in
% each direction. Each direction's subplot will show spike rasters from each
% trial in that direction, as well as a peristimulus time histogram showing
% the average spike rate in a given time after the trial started.
%
% This function is called with a specific channel (electrode) to be plotted
% 
% USAGE:         figh = MakeReachingFigure( filename, chan )
%
% INPUTS:        filename         Name of .mat file containing reachingData variable.
%                chan             Which electrode (channel) of data to plot.
% OUTPUTS:
%                figh             Handle of the resulting figure.
%
% Started by Sergey Stavisky on 15 October 2011
% Completed by YOU on ______


function figh = MakeReachingFigure( filename, chan )

    % ******************************************************************
    %                    Parameters
    % ******************************************************************
    numDirs = 8; % number of different reach directions.
    targetOnT = 50; % time at which the target came on the screen (in ms)
                   % We'll want a vertical line through each direction's subplot
                   % at this time to make it visually clear when this happened.
    epochOfInterest = [200 400]; % Want a shaded region of the plot between these
                                 % start and stop times (in ms)
    binTime = 50;  % For the PSTH, bin spikes every <binTime> milliseconds.    
    
    % These parameters are passed to the plotting functions for each direction,
    % and help ensure uniformity across all of them.
    params.plotTimeLimits = [0 800]; % plot data in this time range (ms). 
                                     % [In this data set, different trials are of different lengths, but all are at
                                     % least 800ms long. The analysis is simpler if we don't worry about the
                                     % post-800ms epoch, for which there may be data from some trials but not others.]
    params.maxExpectedBinRate  = 100; % We don't expect more than this firing rate in a bin. This is used
                                     % to determine where in the axis to start the rasters so that they are
                                     % above all of the PSTH bars.
    params.epochShadeColor = [0 .2 1]; % The epochOfInterest will be shaded in this color.
    
    % ******************************************************************
    %                       Load Data
    % ******************************************************************
    try % The try syntax tries to run a line, and if it fails, runs the catch block
        load( filename )
    catch 
        error('Could not load %s, check filename', filename )
    end
    
    % Make sure a structure named reachingData is now in the workspace. 
    if ~exist( 'reachingData', 'var' )
        error('[%s] Could not find variable ''reachingData'' upon load. Check your data file.')
    end
    

    % This is a lookup table of which subplot each direction of reaches should be 
    % plotted in. Try loading the data and see the reachingData.targetDir
    % field to see which elemement of the structure corresponds to which 
    % direction's reaches. Then fill in this table based on which subplot index
    % that direction should go in (e.g. the upward ('N'orth) reach trials
    % should be plotted in the subplot index which corresponds to the 
    % top-center subplot axis. Remember that subplot numbers them from
    % top left to bottom right, as if you were reading a page (the technical
    % term for this is 'rasterwise'.) 
    directionIndexToSubplotLookup = [ 1 2 3 4 5 6 7 8]; % This order is incorrect; reorder it correctly!
    
    % ******************************************************************
    %                         Create the figure 
    % ******************************************************************
    
    % Create a figure. You might want to already give it a name 
    % by adding the optional argument pair figure('Name', yourNameHere) when calling figure.
    % Keep track of the figure handle with a variable; figh is the suggested variable name.

    % [ YOUR CODE HERE ]
    
    

    % Let's make this figure kind of large so it's easy to see the subplots as they are added in.
    % Note that you can always resize it later. To do this, set the 'Position' property of your
    % figure to be [screenXposition screenYPosition width height]. The screen position doesn't
    % really matter as long as it's visible. [1 1 1000 1000] would make the figure 1000x1000 pixels
    % and place it at the top-left of your screen. Note that on some linux machines this command
    % doesn't work for some reason; you'll have to just accept default size and manually drag-resize
    % the figure to suit you.

    % [ YOUR CODE HERE ]
    

    
    
    
    % ******************************************************************
    %   Loop across the eight directions and create the subplot for each 
    % ******************************************************************
    % This will be the meat of the figure making. It loops through the
    % eight different directions' of data
    
    for iDir = 1 : numDirs       
        % Pull out the spike time data for this direction and this channel.
        % And put it into variable called thisDirSpiketimes.
        % Hint: You should get a 12x1 cell array, with each cell containing
        % a vector of spike times.
        
        % [ YOUR CODE HERE ]
        
        % -----------------------------------------------------------
        %                   CREATE THE SUBPLOT.
        % -----------------------------------------------------------
        % Recall that we want a 3x3 grid, and that each direction gets
        % plotted into one of the eight noncenter subplots.
        mySubplotIdx = directionIndexToSubplotLookup(iDir); % use this for the third
        % argument into subplot function to correctly choose at which location 
        % this direction's plot should be created.
        
        % Let's define variable myAxh to be the output of your call to subplot.
        % This will be the handle of the axis you've just created; you can pass this
        % and the requisite data into the specific raster, histogram, and region of interest
        % functions. 
        
        % [ YOUR CODE HERE ]
        
        
        % -----------------------------------------------------------
        %                       RASTER PLOT
        % -----------------------------------------------------------
        % Call the raster plot function for this direction's data. Make sure to pass
        % it the handle of the subplot axis it should plot to (which you just 
        % created above).
        myAxh = drawRasters( myAxh, thisDirSpiketimes, params.plotTimeLimits, params.maxExpectedBinRate );
        
        % Now let's add code to draw the vertical line to mark target onset.
        % You may be wondering why I didn't suggest that this happen in drawRasters function.
        % This is ebcause we want the raster function to be widely reusable and thus
        % relatively narrow in its function. Thus, the way I've laid it out, it doesn't have 
        % an argument which would specifiy a location for a vertical line to mark target onset
        % (which is specific to this particular type of experiment.) Fortunately, since
        % you have the axis handle, you can call a line command which operates on
        % this axis handle right here in MakeReachingFigure.m. 
        % Draw a vertical line with x endpoints [targetOnT targetOnT]. 
        % You want the line to go from the bottom to the top
        % of the axis, so first get the ylim of the plot and use that in your line command,
        % similar to one of the in-class examples.
        
        
        % CALL THE LIMIT QUERY COMMAND AND LINE COMMAND FOR THE VERTICAL LINE HERE
        % [ YOUR CODE HERE ]
    
        % -----------------------------------------------------------
        %                       PSTH PLOT
        % -----------------------------------------------------------
        myAxh = drawPSTH( myAxh, thisDirSpiketimes, params.plotTimeLimits, binTime );
        
        % Extra nicety; to make the plot look less busy, let's get rid of all of the 
        % y tick labels greater than params.maxExpectedBinSpikes (i.e the tick labels
        % that would be to the left of the raster section of the plot.
        yticklabels = get( myAxh, 'YTickLabel' ); % Get the labels (will be a char array)
        numerical =  str2num( yticklabels ); % convert from characters to numbers
        % Here's the key operation; make all of the labels that are of numbers greater than the
        % max rate we want to display a space  ' '
        yticklabels( (numerical > params.maxExpectedBinRate),: ) = ' ';
        % Now put these labels back into the axis YTickLabel property
        set( myAxh, 'YTickLabel', yticklabels );
        
        % -----------------------------------------------------------
        %                SHADED EPOCH OF INTEREST
        % -----------------------------------------------------------
        myAxh = addShadedEpoch( myAxh, epochOfInterest, params.epochShadeColor );
        % NOTE that you don't even have an incomplete addShadedEpoch.m provided to you.
        % You will need to create this function yourself, in such a way that
        % it expects these three arguments and uses them to make a semi-transparent
        % shaded patch over the epochOfInterest as seen in the example figure.
        % Don't forget to have a nicely documented function header comments at the
        % top of your function similar to that of drawPSTH.m and drawRasters.m.
        
    end %for iDir = 1 : numDirs
    
    
    % ******************************************************************
    %          Let's write some text into the center subplot
    % ******************************************************************
    % It's generally good to put some useful annotation into a figure
    % so that you know what you're looking at. In this case, we want one 
    % line of text in the center identifying the data filename loaded,
    % and a second line identifying which electrode (channel) is being 
    % displayed.
    
    % Please define myAxh to be the center subplot
    % [ YOUR CODE HERE ]
    
    % To make things prettier, we can make this center axis appear
    % invsible by setting its color and its X,Y line/text colors to the background 
    % color of the figure.
    backgroundColor = get(figh, 'Color');
    set( myAxh, 'Color', backgroundColor, 'XColor', backgroundColor, 'YColor', backgroundColor, 'Box', 'off');
    set( myAxh, 'XLim', [0 1], 'YLim', [0 1] ); % now you know what the limits are,
                                                % and can use the text(x,y,YourString)
                                                % function to write to its center
    % Now define the two lines you want to add, 
    line1 = sprintf( '%s Reach Data ', filename );
    line2 = sprintf( 'Channel %i', chan );
    
    % Finally, go ahead and add these two lines of text into this center
    % figure.
    % Hint: use the text command. Use 'HorizontalAlignment', 'Center'
    % and 'VerticalAlignment', 'Bottom' (for top line of text)
    % and 'VerticalAlignment', 'Top' (for bottom line of text)
    % to make it much easier to choose correct x,y coordinates.
    % Hint2: Change the 'Interpreter' text property to 'None' so that
    % underscores do not cause the next character to be subscript.
   
    % [ YOUR CODE HERE ]

end %function