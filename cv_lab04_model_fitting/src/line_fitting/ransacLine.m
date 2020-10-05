function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

    for i=1:iter
        % Randomly select 2 points and fit line to these
        % Tip: Matlab command randperm / randsample is useful here
        rand_columns = randperm(200, 2);
        line_points = data(:,rand_columns);

        % Model is y = k*x + b. You can ignore vertical lines for the purpose
        % of simplicity.
        k=(line_points(2,2)- line_points(2,1))/(line_points(1,2)- line_points(1,1));
        b= line_points(2,2) - k*line_points(1,2);

        % Compute the distances between all points with the fitting line
        distance_of_points = distance_point_to_line(line_points, data);
        %distance_of_points = [1:length(data) ; distance_point_to_line(line_points, data)];

        % Compute the inliers with distances smaller than the threshold
        inliers_num = 0;
        for i = 1:length(distance_of_points)
            if (distance_of_points(i)<threshold)
                inliers_num = inliers_num + 1;
            end
        end

        % Update the number of inliers and fitting model if the current model
        % is better.
        if (inliers_num > best_num_inliers)
            best_num_inliers = inliers_num;
            best_k = k;
            best_b = b;

        end
    end
    
best_k;
best_b;

end
