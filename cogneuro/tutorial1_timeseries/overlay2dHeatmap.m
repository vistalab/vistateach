function imRgb = overlay2dHeatmap(background, overlay, threshold)
% Ovelay a colormap on a background image
%
% imRgb = overlay2dHeatmap(background, overlay, threshold)
%
% background = the background image
% overlay    = the overlay image
% threshold  = a threshold below which to show the background

figure

% Make a truecolor image of the background
rgbBack = reshape(vals2colormap(background(:),'gray'),[size(background) 3]);
% Find overlay values above 0
mask = overlay>threshold;
% Make a truecolor image of overlay
rgbOver = reshape(vals2colormap(overlay(:),'jet'),[size(overlay) 3]);
% Replace the background pixels with the overlay pixels
rgbBack(repmat(mask,[1,1,3])) = rgbOver(repmat(mask,[1,1,3]));
% Show it
imshow(rgbBack)
