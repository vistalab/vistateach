
% GN
% - In the LAB metric, what do L*,a, and b each visually correspond to.
% - Section illustrating colors as vectors, color spaces?
% - Explain why have these color spaces?
% - Get questions from old homeworks (there's one that hasn't been used.)


% USING CIELAB TO COMPARE IMAGES


% Let us define the colors yellowRGB = [1.0 1.0 0.0], 
% blueRGB = [0.25 0.625 1.0], and greenRGB = [0.625, 0.8125, 0.5]
%
% a) Compute the XYZ values for these colors when displayed on our 
% "standard" monitor.  (Ignore gamma correction)

yellowRGB = [1 1 0]';
blueRGB   = [0.25 0.625 1]';
greenRGB  = [0.625 0.8125 0.5]';
load cMatch/monitor;

load XYZ;
XYZ = data;
rgb2xyz = XYZ'*phosphors;

colorXYZ = rgb2xyz * [yellowRGB, blueRGB, greenRGB]

% % colorXYZ =
% % 
% %    62.0592   52.0468   57.0530
% %    84.6287   58.8485   71.7386
% %    13.7069  127.3905   70.5487

% b) Compute the LAB values for these colors for a white point of 
% whiteXYZ = [95 100 108]

whiteXYZ = [95 100 108];
colorLAB = vcXYZ2lab( colorXYZ.', whiteXYZ.' ).'

% % colorLAB =
% % 
% %    93.7229   81.2082   87.8426
% %   -39.1022   -9.8722  -25.7505
% %    88.6691  -43.7166    5.5048

%  Change to white point to whiteXYZ = [108 100 95]; and now evaluate. Does
%  the white point have a big effect?  Does changing the white point have
%  the same effect on L, a* and b*?
%
% %    93.7229   81.2082   87.8426
% %   -57.2587  -26.9945  -43.4050
% %    84.2790  -52.9466   -2.0749
% 
%  The L* is the same because the Y is the same in the two white points.
% But the a* and b* change significantly.

% c) Compute the delta E difference between each combination of of colors.
% Based on these results, which pair of colors is most dissimilar?

deYB = norm( colorLAB(:,1) - colorLAB(:,2) )
deYG = norm( colorLAB(:,1) - colorLAB(:,3) )
deGB = norm( colorLAB(:,2) - colorLAB(:,3) )

% % deYB =  136.1505
% % deYG =   84.4343
% % deGB =   52.1429



% d) Use the following code to generate three images imYB1, imYB2, and imG.
% (Do not submit these images)

imw = 128;
imYB1 = repmat(reshape(yellowRGB,1,1,3), [256 imw]);
ss = 1;
for ii = 1:ss
    imYB1(ii:(2*ss):256, :, :) = ...
        repmat(reshape(blueRGB,1,1,3), [256/ss/2 imw]);
end
imYB2 = repmat(reshape(yellowRGB,1,1,3), [256 imw]);
ss = 16;
for ii = 1:ss
    imYB2(ii:(2*ss):256, :, :) = ...
        repmat(reshape(blueRGB,1,1,3), [256/ss/2 imw]);
end

imG = repmat(reshape(greenRGB,1,1,3), [256, imw]);

% Measure the difference between imYB1 and imG, and the difference between
% imYB2 and imG and compare these values.  Define the difference between 
% two images to be the average delta E difference at each pixel.  Use the 
% white point given above.

% Hints: 
% - You may find the command
%   imdata = reshape(im, size(im,1)*size(im,2),3);
% useful for transforming an m x n x 3 image into an (m*n) x 3.

% - You can use vcXYZ2lab to convert XYZ data to LAB data in bulk.
% vcXYZ2lab will take an nx3 matrix of XYZ values to LAB values 
% (where each row is an XYZ color vector).


dataRGB_imG = reshape(imG, size(imG,1)*size(imG,2), 3);
dataXYZ_imG = (rgb2xyz * dataRGB_imG')';
dataLAB_imG = vcXYZ2lab( dataXYZ_imG, whiteXYZ' );

dataRGB_imYB1 = reshape(imYB1, size(imYB1,1)*size(imYB1,2), 3);
dataXYZ_imYB1 = (rgb2xyz * dataRGB_imYB1')';
dataLAB_imYB1 = vcXYZ2lab( dataXYZ_imYB1, whiteXYZ' );

dataRGB_imYB2 = reshape(imYB2, size(imYB2,1)*size(imYB2,2), 3);
dataXYZ_imYB2 = (rgb2xyz * dataRGB_imYB2')';
dataLAB_imYB2 = vcXYZ2lab( dataXYZ_imYB2, whiteXYZ' );

clear de;
for ii=1:size(dataLAB_imG,1)
    de(ii) = norm(dataLAB_imG(ii,:) - dataLAB_imYB1(ii,:));
end
deGYB1 = mean(de)
for ii=1:size(dataLAB_imG,1)
    de(ii) = norm(dataLAB_imG(ii,:) - dataLAB_imYB2(ii,:));
end
deGYB2 = mean(de)

% 
% % deGYB1 =   68.2886
% % deGYB2 =   68.2886


% e) View the images side by side and compare the images.  Does the visual 
% similarity of imYB1 vs imG and of imYB2 vs imG agree with the delta E 
% values you computed?  If they differ, explain why or suggest a way to
% improve the CIELAB metric so it more accurately reflects the perceived difference.
% What things that we reviewed in class might help develop a modification
% of the metric?  

% % imYB1 should look a lot more like imG because the bars are much
% % finer.










% % Make a set of points that fall along a line in LAB space between(50,0,0) and (60,30,20).  You can do
% % this by creating the weighted sum of these two vectors
% w = [0:.01:1];
% p1 = [50,-10,-30];
% p2 = [80,10,30];
% 
% for ii=1:length(w)
%     l(:,ii) = w(ii)*p1 + (1-w(ii))*p2;
% end
% %  Compute and plot the XYZ values for points along this line.
% %
% whiteP = [100,100,100];
% lineXYZ = lab2xyz([l(1,:)',l(2,:)',l(3,:)'],whiteP)
% plot3(l(1,:),l(2,:),l(3,:),'-.'); grid on;
% plot3(lineXYZ(:,1),lineXYZ(:,2),lineXYZ(:,3),'-o'); grid on;

% TODO:  Show the effect of changing the white point on the delta E.
% 
% 

% TODO:  Start with a couple of spectra and show how delta E differences
% are very hard to predict from the spectra alone.
% 

% TODO:  Introduce a spatial pattern and show that this only works
% pretty well for low frequency patterns, but not for high
% spatial frequency patterns.  



% Question:
%  Set the white point to whiteXYZ = [100,100,100]; 
%  Consider the point       pXYZ   = [50,100,100];
%  What is the delta E spacing between pXYZ and another point that differs
%  by 5 units (e.g., [55,100,100]) in each principle direction.
%
% pXYZ = [100,100,100];
% p = vcXYZ2lab([90,100,100],[100,100,100])
% pX = vcXYZ2lab(pXYZ+[5,0,0],[100,100,100])
% pY = vcXYZ2lab(pXYZ+[0,5,0],[100,100,100])
% pZ = vcXYZ2lab(pXYZ+[0,0,5],[100,100,100])
% [norm(p-pX),norm(p-pY),norm(p-pZ)]