% tutorialInit - script
%
% We assume the user can run this file
%

%% Add the tutorial subdirectories to the user's path
p1 = tutorialRootPath;
path(path,p1);
path(path,sprintf('%s/cMatch', p1));
path(path,sprintf('%s/chromAb', p1));
path(path,sprintf('%s/data', p1));
path(path,sprintf('%s/images', p1));
path(path,sprintf('%s/isetUtility', p1));
path(path,sprintf('%s/jpegFiles', p1));
path(path,sprintf('%s/printing', p1));

%% Clean up
fprintf('Done initializing Psych 221 Tutorial path.\nRoot path: %s\n',p1);
clear p1

