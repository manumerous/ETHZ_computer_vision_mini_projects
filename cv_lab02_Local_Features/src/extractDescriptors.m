% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)

 [img_height, img_width] = size(img);
 internal_keypoints =0;
 pixel_bound = 5;
 
for i=1:length(keypoints)

     k = keypoints(:,i);
     
     if (k(1)>pixel_bound) & (k(1)<(img_height-pixel_bound)) & (k(2)>pixel_bound) & (k(2)<(img_width-pixel_bound))
        if size(internal_keypoints) == 1
            internal_keypoints = k;
        else
            internal_keypoints = [internal_keypoints, k];
        end     
     end 
end
 
 patch_size = 9;
 keypoints = internal_keypoints;
 descriptors = extractPatches(img, keypoints, patch_size);

end