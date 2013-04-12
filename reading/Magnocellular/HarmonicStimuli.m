%
% Illustrate flickering harmonics and drifting harmonics
%


x = [1:256]/256;
f = 2;
contrast = 0.5;
fps = 32;

stimulus = contrast*(sin(2*pi*f*x) + 1);
stimulus = repmat(stimulus,256,1);
imshow(stimulus); colormap(gray(256));

contrast = [-1:.1:1];
contrast = [contrast,fliplr(contrast)];

for jj=1:length(contrast)
    clear stimulus
    stimulus = (contrast(jj)*sin(2*pi*f*x)*128 + 129);
    stimulus = repmat(stimulus,256,1);
    image(stimulus); colormap(gray(256));
    M(jj) = getframe;
end
MPGWRITE(M, gray(256), 'flicker',[0 0 0 1]);

ph = [0:.01:3]*2*pi;
clear M
for jj=1:length(ph)
    clear stimulus
    stimulus = 0.5*sin(2*pi*f*x + ph(jj))*128 + 129;
    stimulus = repmat(stimulus,256,1);
    image(stimulus); colormap(gray(256));
    M(jj) = getframe;
end
MPGWRITE(M, gray(256), 'drift',[0 0 0 1]);
