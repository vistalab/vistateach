%%
parms.freq = 1
parms.ph= 0
parms.ang= pi/2
parms.row= 32
parms.col= 128
parms.GaborFlag= 1

img1 = [];
for c = [0.1:0.025:0.7]
    parms.contrast= c
    tmp = imageHarmonic(parms);
    img1 = [img1; tmp];
end

f = figure(1); image(img1*255); colormap(gray(255))
truesize(f); axis off

%%
parms.freq = 8
parms.ph= 0
parms.ang= pi/2
parms.row= 32
parms.col= 128
parms.GaborFlag= 0

img2 = [];
for c = [0.1:0.025:0.7]
    parms.contrast= c
    tmp = imageHarmonic(parms);
    img2 = [img2; tmp];
end

f = figure(1); image(img2*255); colormap(gray(255))
truesize(f); axis off
%%
img =[img1,img2];

f = figure(1); image(img*255); colormap(gray(255))
truesize(f); axis off
