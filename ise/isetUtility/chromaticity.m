function xy = chromaticity( XYZ )
%
%       xy = chromaticity( XYZ )
%
% Author: ImagEval
% Purupose:
%
%	Calculate chromaticity coordinates from XYZ values.  The same routine
%	can be (ab)used to calculate rg coordinates from RGB values.
%
%  The input (XYZ) data can be sent in XW or RGB format.
%  In XW format, we expect N rows corresponding to spatial positions and
%  three columns containing in X,Y and Z. The chromaticity coordinates
%  (x,y) are returned in the columns of an Nx2 matrix.  
%  
%  If the data are in RGB format, the three planes are (X,Y,Z) images.  The
%  returned data are in an (x,y) format.
%

if ndims(XYZ) == 2
   
   if size(XYZ,2) ~= 3
      error('The XW input data should be in the columns of a Nx3 matrix')
   end
   
   ncols = size(XYZ,1);
   xy = zeros(ncols,2);
   
   s = sum(XYZ')';
   xy(:,1) = XYZ(:,1) ./ s;
   xy(:,2) = XYZ(:,2) ./ s;
   
elseif ndims(XYZ) == 3

   [r c n] = size(XYZ);
   xy = zeros(r,c,2);
   
   s = XYZ(:,:,1) + XYZ(:,:,2) + XYZ(:,:,3);
   xy(:,:,1) = XYZ(:,:,1) ./ s;
   xy(:,:,2) = XYZ(:,:,2) ./ s;
else	
   error('Data must be either Nx3 with XYZ in columns or NxMx3 with XYZ in image planes');
end

return;


