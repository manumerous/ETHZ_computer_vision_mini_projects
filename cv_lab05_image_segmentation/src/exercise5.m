function run_ex5()

% load image
img = imread('cow.jpg');
figure, imshow(img), title('original image')
% for faster debugging you might want to decrease the size of your image
% img = imresize(img, 1/2) ;
% figure, imshow(img), title('low res image')
% (especially for the mean-shift part!)

%% smooth image (6.1a)
F = fspecial('gaussian',5,5); % first is the filter size (5x5), second is std deriviation 
imgSmoothed = imfilter(img,F, 'replicate');
figure, imshow(imgSmoothed), title('smoothed image')

%% convert to L*a*b* image (6.1b)
% (replace the folliwing line with your code to convert the image to lab
cform = makecform('srgb2lab');
imglab = applycform(imgSmoothed, cform);
figure, imshow(imglab), title('l*a*b* image')


%% (6.2)
[mapMS peak] = meanshiftSeg(imglab);
visualizeSegmentationResults(mapMS,peak);

%% (6.3)
[mapEM cluster] = EM(imglab);
visualizeSegmentationResults (mapEM,cluster);

end