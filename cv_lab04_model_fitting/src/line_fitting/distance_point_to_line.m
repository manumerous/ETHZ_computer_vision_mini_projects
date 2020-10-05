function [euclidian_distance] = distance_point_to_line(line_p, point)
% line_p: a 2x2 matrix containing the two points spanning the line
% point: point to find the distance to. 2x1 vector 

% initialize variables for better readability
x1 = line_p(1,1);
x2 = line_p(1,2);
y1 = line_p(2,1);
y2 = line_p(2,2);
x0 = point(1,:);
y0 = point(2,:);


numerator = abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1);
denominator = sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1));

euclidian_distance = numerator/denominator;
end