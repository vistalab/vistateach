function [res,wave,comment] = vcReadSpectra(fname,wave,extrapVal)
%
%   [res,wave,comment] = vcReadSpectra(fname,wave,extrapVal)
%
%Author: ImagEval
%Purpose:
%   Read in a spectral data set and interpolate (possibly extrapolate) 
%   the values to the desired wavelength range.  The routine first looks
%   for data in fname, and then checks for [fname,'.mat'];
%
%   The file must contain a matrix (data) containing the data and a vector (wavelength)
%   specifying the wavelengths of the data in the file.
%
%   If the file does not exist, the return variable, res, is empty on return.
%   If wave is specified, the returned data are interpolated to those values.
%   If wave is not specified, the data are returned at native resolution of the data file 
%      and the values of wavelength can be returned.
%
%   ISET spectral files are generally saved in the form: save(fname,'data','wavelength')
%   and most have comment fields:                        save(fname,'data','wavelength','comment')
%
%   Spectral data files can be written out using the routine ieSaveDatafile();
%
% Example:
%    fullName = vcSelectDataFile([]);
%    wave = 400:10:700;
%    data = vcReadSpectra(fullName,wave)
%    [data,wave] = vcReadSpectra(fname)

% Create a partialpath for this file name.  For this to work, we need to
% keep all of the spectral data in a single directory, I am afraid.
if isempty(fname)
    partialName = vcSelectDataFile('');
    if isempty(partialName), return; end
else
    partialName = fname;
end

test = exist(partialName,'file');
% If partialName is a directory or doesn't exist, we have a problem.
if ~test || test == 7
    partialName = sprintf('%s.mat',partialName);
    if ~exist(partialName,'file')
        % warning(sprintf('Cannot find file %s.',partialName));
        res = []; 
        wavelength = [];
        comment = [];
        return;
    end
end

% Load in spectral data
% We should probably trap this condition so that if it fails the user is sent into
% a GUI to find the data file.
% Also, we should use
% foo = load(partialName)
% if isfield(foo,'comment') ... approach in case the file is missing a
% comment.  Then we should return an empty comment.
tmp = load(partialName);
if isfield(tmp,'data'), data = tmp.data; else data = []; end
if isfield(tmp,'wavelength'), wavelength = tmp.wavelength; else wavelength = []; end
if isfield(tmp,'comment'), comment = tmp.comment; else comment = []; end
if length(wavelength) ~= size(data,1)
    error('Mis-match between wavelength and data variables in %s',partialName);
end

% If wave was not sent in, return the native resolution in the file.  No
% interpolation will occur.
if ieNotDefined('wave'),  wave = wavelength; end
if ieNotDefined('extrapVal'),  extrapVal = 0;  end

res = interp1(wavelength(:), data, wave(:),'linear',extrapVal);
    
return;
