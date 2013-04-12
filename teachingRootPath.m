function rootPath= teachingRootPath()
%
%        rootPath =teachingRootPath;
%
% Determine path to VISTA teaching directory
%
% This function MUST reside in the directory at the base of the VISTA
% teaching directory structure 
%

rootPath=which('teachingRootPath');

[rootPath,fName,ext]=fileparts(rootPath);

return
