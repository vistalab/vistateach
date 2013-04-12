function [MTF, PSF, LSF] = IjspeertMTF(age, p, m, q, phi)

% IjspeertMTF
%
%    [MTF, PSF, LSF] = IjspeertMTF(age, p, m, q, phi) computes 
%    the Modulation Transfer Function, Point Spread Function, 
%    and Line Spread Function of the eye using the expressions 
%    derived by Ijspeert et al, 1993.
%
%    [MTF] = IjspeertMTF(age, p, m, q) computes only the MTF
%    [MTF, PSF] = IjspeertMTF(age, p, m, q, phi) computes MTF and PSF
%    
%    Parameters:
%        age - age of person in years
%        p - pupil diameter in mm
%        m - pigmentation parameter:
%            m=0.142 for Caucasian population mean
%            m=0.16  for mean blue Caucasian eye
%            m=0.106 for mean brown Caucasian eye
%            m=0.056 for mean pigmented-skin dark-brown eye
%        q - spatial frequencies in cycles per degree to compute MTF on 
%        phi - angles in radians to compute PSF and LSF on

% Psych 221 Course Project
% Peter Chou & Sophia Sung
% Winter 1998

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute prefactors c(i) and parameters beta(i) for the critical 
% angle in the functions f_beta
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Dependence on age ---
% 	uses: age, m
% 	produces: AF, c_sa, c_la

D = 70;					% doubling age of long-angle scattering 
					% (relative to the central peak)

AF = 1 + (age/D)^4;			% age factor--the increase of 
					% long-angle scattering with age

c_sa = 1 / (1 + AF / (1/m - 1));	% sum of two short-angle prefactors
c_la = 1 / (1 + (1/m - 1) / AF);	% sum of two long-angle prefactors


% --- Dependence on pupil size ---
% 	uses: p, AF, c_sa
% 	produces: c(1), c(2), beta1, beta2

% the expressions for the following three constants were 
% originally obtained by data fitting:
b = 9000 - 936*(AF^0.5);		% in mm^(-1)
d = 3.2;				% in mm
e = (AF^0.5) / 2000;

c(1) = c_sa / (1 + (p/d)^2);
c(2) = c_sa / (1 + (d/p)^2);

beta(1) = (1 + (p/d)^2) / (b*p);		% in c/rad^(-1)
beta(2) = (1 + (d/p)^2) * (e - 1/(b*p));	% in c/rad^(-1)


% --- Dependence on pigmentation ---
% 	uses: m, AF, c_la
% 	produces: c3, c4, beta3, beta4

c(3) = c_la / ( (1 + 25*m) * (1 + 1/AF) );
c(4) = c_la - c(3);

beta(3) = (10 + 60*m - 5/AF)^(-1);	% in c/rad^(-1)
beta(4) = 1;				% in c/rad^(-1)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Compute MTF
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M_beta(:, :) = exp(-360*beta(:)*q);

MTF = zeros(1, size(q, 2));
for i = 1:4,
    MTF = MTF + c(i) * M_beta(i, :);
end



if (nargin > 4)

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % Compute PSF
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  sinphi2 = sin(phi).^2; 
  cosphi2 = cos(phi).^2; 
  beta2 = beta.^2;

  for i = 1:4,
      f_beta(i, :) = beta(i) ./ ( 2*pi*( sinphi2 ...
                                         + beta2(i) * cosphi2 ).^(1.5) );
  end

  PSF = zeros(1, size(phi, 2));
  for i = 1:4,
      PSF = PSF + c(i) * f_beta(i, :);
  end


  if (nargout == 3)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Compute LSF
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:4,
        l_beta(i, :) = beta(i) ./ ( pi*( sinphi2 + beta2(i) * cosphi2 ) );
    end

    LSF = zeros(1, size(phi, 2));
    for i = 1:4,
        LSF = LSF + c(i) * l_beta(i, :);
    end

  end 	% if (nargout == 3)

end 	% if (nargin > 4)
