function lab = xyz2lab(xyz, whitepoint, exp)
%
% lab = xyz2lab(xyz, whitepoint, exp)
%
% Author: ImagEval
% Purpose:
%   xyz2lab is obsolete.  Use vcXYZ2lab. This routine will do that for you.
%    But change your code.

warning('xyz2lab is obsolete.  Use vcXYZ2lab.  Calling it for you now.');

lab = vcXYZ2lab(xyz,whitepoint);

return;

% 
% if (nargin<3)
%   exp = 1/3;
% end
% if (nargin<2)
%   disp('Using XYZ values of normalized D65 (95.05, 100, 108.88) as white point.');
%   disp('You should really provide your own white point data to ensure reasonable results.');
%   whitepoint = [95.05 100 108.88];
% end
% 
% % Set the white point values
% 
% if ( length(whitepoint)~=3 )
%     error('whitepoint must be a three vector')
% else
%     Xn = whitepoint(1); 
%     Yn = whitepoint(2); 
%     Zn = whitepoint(3);
% end
% 
% if ndims(xyz) == 3
%     [r,c,w] = size(xyz);
%     
%     x = xyz(:,:,1)/Xn; x = x(:);
%     y = xyz(:,:,2)/Yn; y = y(:);
%     z = xyz(:,:,3)/Zn; z = z(:);
%     
%     lab = zeros(r*c,3);
% 
% elseif ndims(xyz) == 2
%     x = xyz(:,1)/Xn;
%     y = xyz(:,2)/Yn;
%     z = xyz(:,3)/Zn;
%     
%     % allocate space
%     lab = zeros(size(xyz));
% 
% end
% 
% % Find out points < 0.008856
% xx = find(x <= 0.008856);
% yy = find(y <= 0.008856);
% zz = find(z <= 0.008856);
% 
% 
% 
% % compute L* values
% % fx, fy, fz represent cases <= 0.008856
% fy = y(yy);
% y = y.^exp;
% lab(:,1) = 116*y-16;
% lab(yy, 1) = 903.3 * fy;
% 
% % compute a* b* values
% fx = 7.787 * x(xx) + 16/116;
% fy = 7.787 * fy + 16/116;
% fz = 7.787 * z(zz) + 16/116;
% x = x.^exp;
% z = z.^exp;
% x(xx) = fx;
% y(yy) = fy;
% z(zz) = fz;
% 
% lab(:,2) = 500 * (x - y);
% lab(:,3) = 200 * (y - z);
% 
% % return lab in the appropriate shape
% % Currently it is a XW format.  If the input had three dimensions
% % then we need to change it to that format.
% if ndims(xyz) == 3
%     lab = XW2RGBFormat(lab,r,c);
% end
% 
% return;