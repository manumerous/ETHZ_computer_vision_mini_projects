%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)

%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

%compute reprojection error 
[~, num_points] = size(xy_normalized);

xy_projected = P * XYZ_normalized;

for i = 1:num_points
    scale = xy_projected(3,i);
    xy_projected(:,i) = xy_projected(:,i)/scale;
end

%compute cost function value
total_error = xy_projected - xy_normalized;
f = sum(vecnorm(total_error,2,1));
end