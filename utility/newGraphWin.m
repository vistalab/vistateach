function figHdl = newGraphWin(figHdl, fType, varargin)
% Open a window for plotting
%
%    figHdl = newGraphWin([fig handle],[figure type],varargin)
%
% A graph window figure handle is returned.
%
% The varargin is a set of (param,val) pairs that can be used for
% set(gcf,param,val);
%
% A few figure shapes can be defaulted
%   fType:  Default - Matlab normal figure position
%           upper left
%           tall 
%           wide
%   This list may grow.
%
% Examples
%  newGraphWin;
%  newGraphWin([],'upper left')   
%  newGraphWin([],'tall')
%  newGraphWin([],'wide')
%
%  newGraphWin([],'wide','Color',[0.5 0.5 0.5])
%
%%
if notDefined('figHdl'), figHdl = figure; end
if notDefined('fType'),  fType = 'upper left'; end

set(figHdl,'Name','GraphWin','NumberTitle','off');
set(figHdl,'Color',[1 1 1]);

% Position the figure
fType = paramFormat(fType);
switch(fType)
    case 'upperleft'
        set(figHdl,'Units','normalized','Position',[0.007 0.55  0.28 0.36]);
    case 'tall'
        set(figHdl,'Units','normalized','Position',[0.007 0.055 0.28 0.85]);
    case 'wide'
        set(figHdl,'Units','normalized','Position',[0.007 0.62  0.7  0.3]);
    otherwise % default
end

%% Parse the varargin arguments
if ~isempty(varargin)
    n = length(varargin);
    if ~mod(n,2)
        for ii=1:2:(n-1)
            set(figHdl,varargin{ii},varargin{ii+1});
        end
    end
end


return;
