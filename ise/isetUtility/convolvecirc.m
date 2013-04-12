function Y = convolvecirc(X,h)
%  
%  Y = convolvecirc(X,h) 
% 
% Author: ImagEval
% Purpose:
%  Performs 2D circular convolution by the matrix h on the matrix X. The
%  result has the same size as X.  
%
%  It is assumed that both the row dimension and column dimension  of h do
%  not exceed those of X.  The result is the same as zero-padding h out to
%  the size of X,  and then computing the convolution X*h.
%

[m,n] = size(X);
Y = conv2(X,h);

[r,s] = size(Y);
Y(1:(r-m),:) = Y(1:(r-m),:) + Y((m+1):r,:);
Y(:,1:(s-n)) = Y(:,1:(s-n)) + Y(:,(n+1):s);

% Clip the result
Y=Y(1:m,1:n);

return;
