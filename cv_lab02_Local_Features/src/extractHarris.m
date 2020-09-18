% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)

[img_height, img_width] = size(img);
[I_x, I_y] = calculateGradients(img);

M_x = zeros(1);
M_p = zeros(1);

I_x2 = imgaussfilt(I_x.^2,sigma);
I_y2 = imgaussfilt(I_y.^2,sigma);
I_xy = imgaussfilt(I_x.*I_y,sigma);

determinante = I_x2.*I_y2-I_xy.*I_xy;
trace_squared = (I_x2+I_y2).^2;

C = determinante -k*(trace_squared);

regional_max = imregionalmax(C);
threshhold_passed = abs(C) > thresh;
corner_collector = 0;

    for y = 1:img_height
        for x = 1:img_width
            if (regional_max(y,x) == 1 & threshhold_passed(y,x) == 1 )
                if size(corner_collector)==1
                    corner_collector = [y;x];
                else
                    corner_collector = [corner_collector, [y;x]];
                end
            end
        end
    end
corners = corner_collector;

end