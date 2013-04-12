% Hi,
% 
% To see some really nice patterns, try really
% large radialValues.  I think you can also see some motion in
% the static image (for large radialValue).
% 
% Brian

% radialValue = 8;
% radialValue = 16;
% radialValue = 64;

[x, y] = meshgrid(-128:127, -128:127);
x(:,129) = eps*ones(256,1);
theta = cos(atan(y./x)*2*radialValue);
theta = scale(theta,0,1);

imshow(128*theta,gray(128)); 

