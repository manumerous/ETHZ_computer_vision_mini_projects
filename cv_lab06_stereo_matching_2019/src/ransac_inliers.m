function [inliers_img1, inliers_img2] = ransac_inliers(img1, img2)

    %addpath helpers
    %don't forget to initialize VLFeat

    img1 = single(img1);
    img2 = single(img2);

    %extract SIFT features and match
    [fa, da] = vl_sift(img1);
    [fb, db] = vl_sift(img2);
    [matches, scores] = vl_ubcmatch(da, db);

    x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))]
    size(x1s)
    x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
    size(x2s)

    % TODO: implement ransac8pF
    [F, inliers] = fundamentalMatrixRANSAC(x1s, x2s);
    
    inliers_img1 = x1s(1:2, inliers);
    inliers_img2 = x2s(1:2, inliers);

    inliers; 
end
