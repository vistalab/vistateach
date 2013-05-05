function fx = normalpdf(x,Mu,SigmaSq)
% Returns the probability density function of Normal(Mu, SigmaSq), at 
% x,
% for
%   Mu=mean 
%   SigmaSq = Variance
%
% Usage: fx = NormalPdf(x,Mu,SigmaSq)
%
% Avoids having to use the statistics toolbox
% http://www.math.canterbury.ac.nz/~r.sainudiin/courses/ENCI303/CodeData/NormalCdf.m
%

if SigmaSq <= 0
   error('Variance must be > 0')
end

Den = ((x-Mu).^2)/(2*SigmaSq);
Fac = sqrt(2*pi)*sqrt(SigmaSq);

fx = (1/Fac)*exp(-Den);

end