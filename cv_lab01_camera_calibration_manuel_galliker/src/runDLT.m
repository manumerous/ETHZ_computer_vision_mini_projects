%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)

%homogenize
XYZh = homogenization(XYZ);
xyh = homogenization(xy);
% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);


%denormalize projection matrix
P = inv(T)*Pn*U;
%P = dlt(xyh, XYZh);

%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

%compute average reprojection error
num_points = length(xy(1,:));

xy_projected = P*XYZh;

for i = 1:num_points
    scaling_factor = xy_projected(3,i);
    xy_projected(:,i) = xy_projected(:,i)/scaling_factor;
end
ErrorTotal = xy_projected - xyh;
error = sum(vecnorm(ErrorTotal,2,1))/num_points

IMG_NAME = 'images/image001.jpg';
visualization_all_points(xy, XYZ, P, IMG_NAME);
visualization_reprojected_points(xy, XYZ, P, IMG_NAME);

end