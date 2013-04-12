function blank = blankSound(t,dT)
%   
%    blank = blankSound(t,dT)
%
% Author: Wandell
% Purpose:
%   Blank interval of t seconds when there is a sample rate of dT.
%

n = round(t/dT);
blank = zeros(1,n);

end