function lab = vcXYZ2lab(xyz, whitepoint, useOldCode)
%
% lab = vcXYZ2lab(xyz, whitepoint, flag)
%
% Author: ImagEval
% Purpose:
%   Convert XYZ values into CIEL*a*b* values with respect to the
%   whitepoint.
%   
%   This routine is based on the Matlab image toolbox routines makecform and applycform.
%   The code we used for many years to is  contained in the comment fields.
%
%   xyz:        can be in either XW or RGB format.
%   whitepoint: a 3-vector of the xyz values of the white point.
%
%    LAB values are returned in the same format (RGB or XW) as the input
%    xyz. 
%
% Read about CIELAB formulae are taken from Wyszecki and Stiles, page 167
% or other standard texts.

if ieNotDefined('xyz'), error('No data.'); end
if ieNotDefined('whitepoint'), error('A whitepoint is required for conversion to CIELAB.'); end
if ieNotDefined('useOldCode'), useOldCode = 0; end

if (exist('makecform') == 2) | useOldCode
    % This is where we want to be, but it only exists in the relatively
    % recent Matlab routines.
    cform = makecform('xyz2lab','WhitePoint',whitepoint(:)');
    lab = applycform(xyz,cform);
    return;
    
else
    % Older Matlab versions (6.5.1) don't have makecform or applycform.  So, we
    % have our own code here.
    % Set the white point values
    
    if ( length(whitepoint)~=3 )
        error('whitepoint must be a three vector')
    else
        Xn = whitepoint(1); 
        Yn = whitepoint(2); 
        Zn = whitepoint(3);
    end
    
    if ndims(xyz) == 3
        [r,c,w] = size(xyz);
        
        x = xyz(:,:,1)/Xn; x = x(:);
        y = xyz(:,:,2)/Yn; y = y(:);
        z = xyz(:,:,3)/Zn; z = z(:);
        
        lab = zeros(r*c,3);
        
    elseif ndims(xyz) == 2
        x = xyz(:,1)/Xn;
        y = xyz(:,2)/Yn;
        z = xyz(:,3)/Zn;
        
        % allocate space
        lab = zeros(size(xyz));
        
    end
    
    % Find out points < 0.008856
    xx = find(x <= 0.008856);
    yy = find(y <= 0.008856);
    zz = find(z <= 0.008856);
    
    % compute L* values
    % fx, fy, fz represent cases <= 0.008856
    fy = y(yy);
    y = y.^(1/3);
    lab(:,1) = 116*y-16;
    lab(yy, 1) = 903.3 * fy;
    
    % compute a* b* values
    fx = 7.787 * x(xx) + 16/116;
    fy = 7.787 * fy + 16/116;
    fz = 7.787 * z(zz) + 16/116;
    x = x.^1/3;
    z = z.^1/3;
    x(xx) = fx;
    y(yy) = fy;
    z(zz) = fz;
    
    lab(:,2) = 500 * (x - y);
    lab(:,3) = 200 * (y - z);
    
    % return lab in the appropriate shape
    % Currently it is a XW format.  If the input had three dimensions
    % then we need to change it to that format.
    if ndims(xyz) == 3
        lab = XW2RGBFormat(lab,r,c);
    end
end 

return;
