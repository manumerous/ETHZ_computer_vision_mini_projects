%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization
%%% xy %%%

% 1. Determine centroid
x = xy(1,:);
y = xy(2,:);
num_points = length(x);

delta_x = -sum(x)/num_points;
delta_y = -sum(y)/num_points;

% 2. shift the input points so that the centroid is at the origin

x_centre = x + delta_x;
y_centre = y + delta_y;

% 3. compute scale
x_scale = sqrt(num_points/(sum(x_centre.*x_centre)));
y_scale = sqrt(num_points/(sum(y_centre.*y_centre)));

% 4. create T transformation matrix (similarity transformation)
T = [x_scale,   0,          delta_x*x_scale;
     0,         y_scale,    delta_y*y_scale;
     0,         0,          1];

% 5. normalize the points according to the transformations
xy_norm = zeros(3,num_points);
xy_hom = [xy; ones(1,num_points)];

for c = 1:num_points
xy_norm(:,c)= T*xy_hom(:,c);
end

xy_normalized = xy_norm;

%%% XYZ %%%

% 1. Determine centroid
X = XYZ(1,:);
Y = XYZ(2,:);
Z = XYZ(3,:);
num_points = length(X);

delta_X = -sum(X)/num_points;
delta_Y = -sum(Y)/num_points;
delta_Z = -sum(Z)/num_points;

% 2. shift the input points so that the centroid is at the origin

X_centre = X + delta_X;
Y_centre = Y + delta_Y;
Z_centre = Z + delta_Z;

% 3. compute scale
X_scale = sqrt(num_points/(sum(X_centre.*X_centre)));
Y_scale = sqrt(num_points/(sum(Y_centre.*Y_centre)));
Z_scale = sqrt(num_points/(sum(Z_centre.*Z_centre)));

% 4. create U transformation matrix (similarity transformation)
U = [X_scale,   0,          0,          delta_X*X_scale;
     0,         Y_scale,    0,          delta_Y*Y_scale;
     0,         0,          Z_scale,    delta_Z*Z_scale;
     0,         0,          0,          1];

% 5. normalize the points according to the transformations
XYZ_norm = zeros(4,num_points);
XYZ_hom = [XYZ; ones(1,num_points)];

for c = 1:num_points
XYZ_norm(:,c)= U*XYZ_hom(:,c);
end

XYZ_normalized = XYZ_norm;

end