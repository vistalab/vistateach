function p = plotSpectrumLocus(fig)
%
%   p = plotSpectrumLocus([fig])
%
%Author: ImagEval
%Purpose:
%  Draw the outline of the spectrum locus on the chromaticity
%  diagram.
%

wave = 370:730;
XYZ = vcReadSpectra('XYZ',wave);

if ieNotDefined('fig'), fig = gcf; end

% Here are the shifts in the chromaticity of the display
% as the display intensity shifts
spectrumLocus = chromaticity(XYZ);

% These are the (x,y) points of the spectral lines
p = plot(spectrumLocus(:,1),spectrumLocus(:,2),'-');
hold on;

% Add a line to close up the outer rim of the spectrum locus curve
l = line([spectrumLocus(1,1),spectrumLocus(end,1)],...
    [spectrumLocus(1,2),spectrumLocus(end,2)]);
hold on;

return;