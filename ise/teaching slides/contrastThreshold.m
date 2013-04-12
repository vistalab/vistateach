% Demonstration of a brief psychophysical experiment using two-interval
% forced choice

X = [0:127]/127; f = 6;

s1 = sin(2*pi*f*X);
s1 = repmat(s1,128,1);
g =fspecial('gaussian',128,16); g= g/max(g(:));
s1 = s1.*g;
for ii=1:3, stim(:,:,ii) = s1; end

% Make a blank frame
blank = ones(128,128,3)*0.5;
MBlank = im2frame(blank);

fixation = blank;
fixation(63:65,63:65,:) = .2;

betweenTrial = blank;
betweenTrial(63:65,63:65,:) = .7;

nTrials = 15;
trialType = (rand(1,nTrials) > 0.5);
contrast = logspace(-2,-.6,10);
cLevel = contrast(round(rand(1,nTrials)*(length(contrast)-1)) + 1);

h = figure(1);
set(h,'Color',[.5 .5 .5]);
imshow(fixation);

clear M
M(1) = im2frame(fixation);
M = addToMovie(M,fixation,4);
for ii = 1:nTrials
    imshow(betweenTrial);  M = addToMovie(M,betweenTrial,15);
    pause(1.5);
    switch trialType(ii)
        case 0
            imshow(fixation);  M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            imshow(blank);     M = addToMovie(M,blank,10);
            pause(1)
            imshow(fixation);  M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            img = (stim*cLevel(ii)/2) + .5;
            imshow(img); M = addToMovie(M,img,10);
            pause(1)
        case 1
            imshow(fixation); M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            img = (stim*cLevel(ii)/2) + .5;
            imshow(img); M = addToMovie(M,img,10);
            pause(1)
            imshow(fixation);  M = addToMovie(M,fixation,5);
            beep; pause(0.3)
            imshow(blank); M = addToMovie(M,blank,10);
            pause(1)
    end
end
imshow(betweenTrial);  M = addToMovie(M,betweenTrial,15);
movie2avi(M,'grating2IFC.avi','fps',8,'compression','None');

% movie(M,1,8)


