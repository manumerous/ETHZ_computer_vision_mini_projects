% =========================================================================
% Exercise 8
% =========================================================================

% Initialize VLFeat (http://www.vlfeat.org/)

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
%f=feature/frame, d=descriptor
%fa ->[x;y;scale;orientation]
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);
x_1 = makehomogeneous(fa(1:2, matches(1,:)));
x_2 = makehomogeneous(fb(1:2, matches(2,:)));

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);
title('Matches from vl_ubcmatch')

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices
[F, inliers] = ransacfitfundmatrix(x_1,x_2,0.005);
outliers = setdiff(1:size(matches,2),inliers);

x_1_inliers = makeinhomogeneous(x_1(:,inliers)) ;
x_2_inliers = makeinhomogeneous(x_2(:,inliers)) ;


showFeatureMatches(img1, x_1_inliers, img2, x_2_inliers, 2);
title('Matches after ransac')

%%
%Rotation R and Translation t of first camera assumed to be identity
Ps{1} = eye(4);
%P Matrix for second camera
E = K'*F*K;

%roughly equal to inv(K)*makeho....
x1_calibrated = K\makehomogeneous(x_1_inliers);
x2_calibrated = K\makehomogeneous(x_2_inliers);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches with the computed projection matrix
[X_0, err_0] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

%% epipolar lines

% draw epipolar lines for img 0
figure(fig)
fig=fig+1 ;
imshow(img1, []);
hold on 
plot(x_1_inliers(1,:), x_1_inliers(2,:), '*r');
for k = 1:size(x_1_inliers,2)
    drawEpipolarLines(F'*makehomogeneous(x_2_inliers(:,k)), img1);
end
title('epipolar lines (img0)')

% draw epipolar lines for img 4
figure(fig)
fig=fig+1 ;
imshow(img2, []);
hold on 
plot(x_2_inliers(1,:), x_2_inliers(2,:), '*r');
for k = 1:size(x_2_inliers,2)
    drawEpipolarLines(F'*makehomogeneous(x_1_inliers(:,k)), img2);
end
title('epipolar lines (img4)')

%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
%compare to the already obtained matches
fa_inliers = fa(:,matches(1,inliers));
da_inliers = da(:,matches(1,inliers));

[matches1, ~] = vl_ubcmatch(da_inliers, dc);

x_1_inliers2 = makehomogeneous(fa_inliers(1:2, matches1(1,:)));
x_3_inliers2 = makehomogeneous(fc(1:2, matches1(2,:)));

x_1_inliers2_ih = makeinhomogeneous(x_1_inliers2) ;
x_3_inliers_ih = makeinhomogeneous(x_3_inliers2) ;

showFeatureMatches(img1, x_1_inliers2_ih, img3, x_3_inliers_ih, 2);
title('Matches after ransac')



%run 6-point ransac
x_1_inliers2_calibrated = K\x_1_inliers2;
x_3_inliers2_calibrated = K\x_3_inliers2;
[Ps{3}, inliers3] = ransacfitprojmatrix(x_3_inliers2_calibrated, X_0(:,matches1(1,:)), 0.05) ;
outliers3 = setdiff(1:size(matches1,2),inliers3);

if (det(Ps{3}) < 0 )
    Ps{3}(1:3,1:3) = -Ps{3}(1:3,1:3);
    Ps{3}(1:3, 4) = -Ps{3}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
[X_1, err1] = linearTriangulation(Ps{1}, x_1_inliers2_calibrated(:,inliers3), Ps{3}, x_3_inliers2_calibrated(:,inliers3));

%% Add more views...

imgName3 = '../data/house.002.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated
%compare to the already obtained matches
fa_inliers = fa(:,matches(1,inliers));
da_inliers = da(:,matches(1,inliers));

[matches2, ~] = vl_ubcmatch(da_inliers, dc);

x_1_inliers2 = makehomogeneous(fa_inliers(1:2, matches2(1,:)));
x_3_inliers2 = makehomogeneous(fc(1:2, matches2(2,:)));

x_1_inliers2_ih = makeinhomogeneous(x_1_inliers2) ;
x_3_inliers_ih = makeinhomogeneous(x_3_inliers2) ;

showFeatureMatches(img1, x_1_inliers2_ih, img3, x_3_inliers_ih, 2);
title('Matches after ransac')



%run 6-point ransac
x_1_inliers2_calibrated = K\x_1_inliers2;
x_3_inliers2_calibrated = K\x_3_inliers2;
[Ps{4}, inliers3] = ransacfitprojmatrix(x_3_inliers2_calibrated, X_0(:,matches2(1,:)), 0.05) ;
outliers3 = setdiff(1:size(matches2,2),inliers3);

if (det(Ps{4}) < 0 )
    Ps{4}(1:3,1:3) = -Ps{4}(1:3,1:3);
    Ps{4}(1:3, 4) = -Ps{4}(1:3, 4);
end

%triangulate the inlier matches with the computed projection matrix
[X_2, err2] = linearTriangulation(Ps{1}, x_1_inliers2_calibrated(:,inliers3), Ps{4}, x_3_inliers2_calibrated(:,inliers3));



%% Plot stuff

fig = 10;
figure(fig);

hold on
%use plot3 to plot the triangulated 3D points
plot3(X_0(1,:),X_0(2,:),X_0(3,:),'r.')
plot3(X_1(1,:),X_1(2,:),X_1(3,:),'g.')
plot3(X_2(1,:),X_2(2,:),X_2(3,:),'b.')
%draw cameras
drawCameras(Ps, fig); hold on ;
view(10,20)
fig=fig+1 ;