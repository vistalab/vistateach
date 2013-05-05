function Fx = normalcdf(x,Mu,SigmaSq)
% Returns the cumulative distribution function of Normal(Mu, SigmaSq), at
%   x 
%   Mu = mean 
%   SigmaSq = Variance 
%
% Uses MATLAB's error function erf
%
% Avoids having to use the statistics toolbox
%
% Usage: Fx = NormalCdf(x,Mu,SigmaSq)
%
% From
% http://www.math.canterbury.ac.nz/~r.sainudiin/courses/ENCI303/CodeData/NormalCdf.m
% 

if SigmaSq <= 0
   error('Variance must be > 0')
   return
end

Arg2Erf = (x-Mu)/sqrt(SigmaSq*2);
Fx = 0.5*erf(Arg2Erf)+0.5;

end
