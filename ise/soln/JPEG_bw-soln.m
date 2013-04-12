% Solutions: JPEG Compression

% JPEG COMPRESSION OF GRAYSCALE IMAGE
%
% a) Describe the initial steps in the JPEG-DCT computation in terms of
% convolution followed by sampling.
%    Imagine that the original image, say 128x128, is convolved with each of the DCT
%    basis functions.  This convolution produces a filtered replica of the
%    original.  Since there are 64 DCT filters, we have 64 filtered
%    replicas of the original image.  Each of these replicas is the same
%    size (row,col) as the original.  
%    
%    Each JPEG image saves only 1 coefficient from the filtered replicas
%    for each block. Specifically, it saves the coefficient centered on
%    each 8x8 image block.  For example, in a 128 x 128 image, there are 32
%    x 32 blocks. Each block in the JPEG image contains one sample from
%    the filtered replica. These 64 coefficients, taken from the 64
%    filters,  define the values in the individual blocks.
%
% b) At what point is information lost in the JPEG-DCT computation?
%    Quantization step.
%
% c) Why is it better to quantize the JPEG-DCT coefficients rather than
% the intensities of individual pixels?
%    Because the quantization can be structured to match the visibility of
%    the terms and thus aggressively compress.
%
% d) Suppose you use JPEG-DCT to compress an image (yielding image a); 
% then you uncompress the image and compress it again (yielding image b).
% How will the two compressed images (a and b) compare?  
% Present in tutorials/images/einstein.mat
load einstein.mat;
% load images/einstein.mat;
im = 256*X/max(X(:));
q = 75;
imwrite(im, 'imgcomp-a.jpg', 'JPEG', 'Quality', q);
imga = imread('imgcomp-a.jpg');
imwrite(imga, 'imgcomp-b.jpg');

diff = [];
diffmax = [];
iter = 1:10;
for ii = iter
    imgb = imread('imgcomp-b.jpg');
    imwrite(imgb, 'imgcomp-b.jpg', 'Quality', q);
    imdiff = ((double(imgb) - double(imga)) ./256) .^ 2;
    diff(ii) = mean(imdiff(:));
    diffmax(ii) = max(imdiff(:));
end
plot(iter,diff,'-',iter,diffmax,'.');
legend('mean','max');
title('Mean-squared error vs. recompressions');
xlabel('Number of recompressions');
ylabel('MSE'); ylim([0 1]);

% It appears that if you give it a fixed-point input (uint8), 
% then the errors will accumulate
load einstein.mat;
% load images/einstein.mat;
im = (truncate(256*X/max(X(:)),0,255));
q = 75;
imwrite(im, 'imgcomp-a.jpg', 'JPEG', 'Quality', q);
imga = imread('imgcomp-a.jpg');
imwrite(imga, 'imgcomp-b.jpg');

diff = [];
diffmax = [];
iter = 1:10;
for ii = iter
    imgb = imread('imgcomp-b.jpg');
    imwrite(imgb, 'imgcomp-b.jpg', 'Quality', q);
    imdiff = ((double(imgb) - double(imga)) ./256) .^ 2;
    diff(ii) = mean(imdiff(:));
    diffmax(ii) = max(imdiff(:));
end
figure;plot(iter,diff,'-',iter,diffmax,'.');
legend('mean','max');
title('Mean-squared error vs. recompressions (fixed-point)');
xlabel('Number of recompressions');
ylabel('MSE'); ylim([0 1]);


% This seems to show that we will lose some quality after a compression
% from A to B.  

% % If you remove the truncate commands, then everything is ok.
% 
% %  Remember that JPEG question about whether compressing an image with
% JPEG once, then recompressing it again with the same quantization table
% will cause badness?  Well, I ran tests that showed that it didn't, but if
% you formulate the problem in a particular way, it will.  
% 
% % This student put in some truncate commands to make the data from
% [0,255], and this truncate command causes image errors.  However, these
% errors settle after a few more recompressions (when the truncate command
% isn't needed any more).  I've put this example into the JPEG_bw solutions
% for future reference.

tmin = 0; tmax = 255;
Q_factor = 50;

im = (imread('images/einstein.tif'));

max(im(:))

q5 = jpeg_qtables(Q_factor,1);
imjpegA = jpegCompress(im, q5);
imjpegA = truncate(imjpegA, tmin, tmax);
imjpegB = jpegCompress(imjpegA, q5);
imjpegB = truncate(imjpegB, tmin, tmax);

diffAB = abs(imjpegA-imjpegB);

maxdiffAB = max(diffAB(:))


    %    
%
% e) What are the main visual artifacts present in JPEG-DCT compressed
% grayscale image?  What types of images will display artifacting most
% visibly?
%   Blocking.
%
% Part II
%
% Read the einstein.mat image, and compress it using JPEG quantization
% levels of 75, 50, 25, and 0.  You may want to use the imread and imwrite
% functions to accomplish this.  Normalize all images to have intensities
% from 0 to 1 (as opposed to 0 to 255).
%
% a) Submit the squared-error image for q=25.  
%
% b) Describe where the error image has the highest values.  Does this
% agree with your understanding of the JPEG-DCT algorithm?
%
% c) For each compressed image, compute the mean squared error and plot the
% error vs. quantization factor. [You may obtain data for more quantization
% settings if you like, but this is not required.]
%
% d) For each error image, compute the 95th percentile error point.  If 
% your error image is called errorim, you can find this value as follows:
%
%    serr = sort(errorim(:)); % sort the error values
%    error95 = serr( floor(0.95 * length(serr)) ); % get the 95th percentile
% 
% Also plot error vs quantization factor for this method.
%
% e) If you were evaluating image quality for this image, which method 
% (c) or (d) would you use?  Describe why you would use this method.

% f) 
