function rootPath=tutorialRootPath()
% Return the path to the root tutorial directory
%
% This function must reside in the directory at the base of the Psych 221
% Tutorial directory structure.  It is used to determine the location of various
% sub-directories.
% 

rootPath=which('tutorialRootPath');

[rootPath,fName,ext]=fileparts(rootPath);

return
