% addShadedEpoch.m
%
% Adds a shaded colored transparent rectangle to a specified axis. This 
% rectangle is a patch which stretches across the entire ylim of the axis
% and between specified start and end x-limits.
%
% USAGE:
%  axh = addShadedEpoch( axh, epochStartEndT, patchColor )
%
% INPUTS:
%      axh              Axis handle where to add this shaded region.
%      epochStartEndT   length 2 vector specifying the [startT endT]
%                       of the region that is to be shaded.
%                       maxExpectedBinSpike.
%      patchColor       RGB vector specifying color to shade the specified epoch
%  
%                       
% OUTPUTS:
%      axh             Same as input axis handle.
% Last Edited by Sergey Stavisky on 15 October 2011
function axh = addShadedEpoch( axh, epochStartEndT, patchColor )

    % PARAMETERS
    transparency = .4; % patch will have this appearance; 0 means fully
                       % transparent, 1 means fully opaque.
   
    % COMPUTE PATCH VERTICES
    % I'll need to know the y boundaries for my shaded rectangle. Get these
    % by querying the axis' y limits.
    myYlim = get( axh, 'Ylim');
    
    % Now define the four corners of the patch.
    patchCoordinates = [epochStartEndT(1) myYlim(1);
                        epochStartEndT(1) myYlim(2);
                        epochStartEndT(2) myYlim(2);
                        epochStartEndT(2) myYlim(1)];
                    
    % DRAW THE PATCH        
    % Now call patch. Remember that it wants separate inputs for the x-coordinates
    % of the vertices and the y-coordinates of the vertices.
    shadeh = patch( patchCoordinates(:,1), patchCoordinates(:,2), patchColor, 'Parent', axh );
    
    % Make the patch partially transparent and its edges to be also be 
    % partially transparent and of patchColor.
    set( shadeh, 'EdgeColor', patchColor, 'FaceAlpha', transparency, 'EdgeAlpha', transparency);

end %function