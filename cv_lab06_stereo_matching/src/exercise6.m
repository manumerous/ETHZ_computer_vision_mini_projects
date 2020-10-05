%% 
% Before starting, you should include the VLfeat (http://www.vlfeat.org/)
% and GCMex packages (https://github.com/shaibagon/GCMex) in your path:
% - for vlfeat under VLF_ROOT/vlfeat-0.9.21/toolbox/ you run vl_setup, 
% which does the job for you,
% - for GCMex under GCM_ROOT/ you run compile_gc, and then do 
% addpath('GCM_ROOT').
% Should you have any problems compiling them under Linux, Windows, Mac, 
% please refer to the corresponding websites for further instructions.

%%
% Rectify images
imgNameL = 'images/0018.png';
imgNameR = 'images/0019.png';
camNameL = 'images/0018.camera';
camNameR = 'images/0019.camera';

scale = 0.5^2; % try this scale first
%scale = 0.5^3; % if it takes too long for GraphCut, switch to this one

imgL = imresize(imread(imgNameL), scale);
imgR = imresize(imread(imgNameR), scale);

figure(1);
subplot(121); imshow(imgL);
subplot(122); imshow(imgR);

[K R C] = readCamera(camNameL);
PL = K * [R, -R*C];
[K R C] = readCamera(camNameR);
PR = K * [R, -R*C];

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

figure(2);
subplot(121); imshow(imgRectL);
subplot(122); imshow(imgRectR);
%close all;

se = strel('square', 15);
maskL = imerode(maskL, se);
maskR = imerode(maskR, se);


%%
grayL = rgb2gray(imgRectL);
grayR = rgb2gray(imgRectR);
%%
% Set disparity range
% (exercise 5.3)
% you may use the following two lines
%[x1s, x2s] = getClickedPoints(imgRectL, imgRectR); 
%close all;
% to get a good guess
[inliers1, inliers2] = ransac_inliers(grayL, grayR);

showFeatureMatches(grayL, inliers1, grayR, inliers2, 1);
pause(1);

matches_SAD = sum(abs(inliers1(1,:)-inliers2(1,:)))/length(inliers1);
safety_factor = 2;
max_range = round(matches_SAD*safety_factor);

% Leave this exercise for the end, and for now try these fixed ranges
% -40:40
dispRange = -max_range:max_range;
%dispRange = -40:40;
%%
% Compute disparities, winner-takes-all
% (exercise 5.1)
% black = distance -40; white = distance 40; Grey = corresponding pixels
% are very close
dispStereoL = ...
    stereoDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRange);
dispStereoR = ...
    stereoDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRange);

figure(1);
subplot(121); imshow(dispStereoL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispStereoR, [dispRange(1) dispRange(end)]);

thresh = 8;

maskLRcheck = leftRightCheck(dispStereoL, dispStereoR, thresh);
maskRLcheck = leftRightCheck(dispStereoR, dispStereoL, thresh);

maskStereoL = double(maskL).*maskLRcheck;
maskStereoR = double(maskR).*maskRLcheck;

figure(2);
subplot(121); imshow(maskStereoL);
subplot(122); imshow(maskStereoR);
%close all;
%%
% Compute disparities using graphcut
% (exercise 5.2)
Labels = ...
    gcDisparity(rgb2gray(imgRectL), rgb2gray(imgRectR), dispRange);
dispsGCL = double(Labels + dispRange(1));
Labels = ...
    gcDisparity(rgb2gray(imgRectR), rgb2gray(imgRectL), dispRange);
dispsGCR = double(Labels + dispRange(1));

figure(1);
subplot(121); imshow(dispsGCL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispsGCR, [dispRange(1) dispRange(end)]);

maskLRcheck = leftRightCheck(dispsGCL, dispsGCR, thresh);
maskRLcheck = leftRightCheck(dispsGCR, dispsGCL, thresh);

maskGCL = double(maskL).*maskLRcheck;
maskGCR = double(maskR).*maskRLcheck;

figure(2);
subplot(121); imshow(maskGCL);
subplot(122); imshow(maskGCR);
%close all;
%%
% Using the following code, visualize your results from 5.1 and 5.2 and 
% include them in your report 
dispStereoL = double(dispStereoL);
dispStereoR = double(dispStereoR);
dispsGCL = double(dispsGCL);
dispsGCR = double(dispsGCR);

S = [scale 0 0; 0 scale 0; 0 0 1];

% For each pixel (x,y), compute the corresponding 3D point 
% use S for computing the rescaled points with the projection 
% matrices PL PR
[coords ~] = ...
    generatePointCloudFromDisps(dispsGCL, Hleft, Hright, S*PL, S*PR);
% ... same for other winner-takes-all
[coords2 ~] = ...
    generatePointCloudFromDisps(dispStereoL, Hleft, Hright, S*PL, S*PR);

imwrite(imgRectL, 'imgRectL.png');
imwrite(imgRectR, 'imgRectR.png');

% Use meshlab to open generated textured model, i.e. modelGC.obj
generateObjFile('modelGC', 'imgRectL.png', ...
    coords, maskGCL.*maskGCR);
% ... same for other winner-takes-all, i.e. modelStereo.obj
generateObjFile('modelStereo', 'imgRectL.png', ...
    coords2, maskStereoL.*maskStereoR);