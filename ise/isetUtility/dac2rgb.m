function RGB = dac2rgb(DAC, GammaTable)

%%%%%%%%%%%%%%%
%%  dac2rgb  %%
%%%%%%%%%%%%%%%
%
% RGB = dac2rgb(DAC, GammaTable)
%
% DAC contains the frame buffer values of the 3 color planes, in the form
%    of [DAC_r DAC_g DAC_b], where DAC_x can be a matrix. DAC values should
%    be in the range [0 1].
% RGB is the linear intensity of each gun, returned in the form of [r g b].
%    To separate the r,g,b planes, use GetPlanes.
%
% GammaTable -- the look up table to go from DAC to linear RGB
%    If it has one column, all DAC values are changed according to this
%    If it has 3 columns and more than one row, treat input image as
%       3 planes and transform to RGB with the corresponding column.
%    If it is a scalar number, raise the DAC values to this power.
%    If it is a 3 vector, raise the r,g,b DAC values to the respective
%       power.
%    If GammaTable is not given, use a default scalar of 2.2.
%
% Xuemei Zhang
% Last Modified 6/19/96

if (nargin==1)
  GammaTable = 2.2;
end

if (prod(size(GammaTable))==1)
  if (nargin==1)
   disp(['Raising DAC values to a power of ' num2str(GammaTable)]);
  end
  RGB = DAC.^GammaTable;
elseif (prod(size(GammaTable))==3)
  disp(['Raising R values to a power of ' num2str(GammaTable(1))]);
  disp(['Raising G values to a power of ' num2str(GammaTable(2))]);
  disp(['Raising B values to a power of ' num2str(GammaTable(3))]);
  [r,g,b] = getPlanes(DAC);
  RGB = [r.^GammaTable(1) g.^GammaTable(2) b.^GammaTable(3)];
else
  DAC = round(DAC * (size(GammaTable,1)-1)) + 1;

  [m,n] = size(DAC);
  if (size(GammaTable,2)==1)
    RGB = GammaTable(DAC(:));
  else
    DAC = reshape(DAC, m*n/3, 3);
    RGB = [GammaTable(DAC(:,1), 1) GammaTable(DAC(:,2), 2) GammaTable(DAC(:,3), 3)];
  end

  RGB = reshape(RGB, m, n);
end

