% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)

% 1. Determine centroid
x = xs(1,:);
y = xs(2,:);
num_points = length(x);

delta_x = -sum(x)/num_points;
delta_y = -sum(y)/num_points;

% 2. shift the input points so that the centroid is at the origin

x_centre = x + delta_x;
y_centre = y + delta_y;

% 3. compute scale
xs_sum_norm = sum(vecnorm([x_centre;y_centre]))/num_points;
scale_f = sqrt(2)/xs_sum_norm;


% 4. create T transformation matrix (similarity transformation)
T = [scale_f,   0,          scale_f*delta_x;
     0,         scale_f,    scale_f*delta_y;
     0,         0,          1];

% 5. normalize the points according to the transformations
xs_norm = zeros(3,num_points);

for c = 1:num_points
xs_norm(:,c)= T*xs(:,c);
end

nxs = xs_norm;


end


