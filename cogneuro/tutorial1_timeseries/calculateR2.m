function R2 = calculateR2(y, yhat)
% Calculate R2 for a model
% R2 = calculateR2(y, yhat)
%
% Inputs:
% y    - Data
% yhat - Model prediction

R2 = sum((y - yhat).^2) ./ sum((y - mean(y)).^2);