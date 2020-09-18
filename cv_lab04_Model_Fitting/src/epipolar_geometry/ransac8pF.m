% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 1000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;

    for i=1:iter
        % Randomly select 8 points and estimate the fundamental matrix using these.
        rand_columns = randperm(num_pts, 8);
        x1i = x1(:,rand_columns);
        x2i = x2(:,rand_columns);

        [Fh, F] = fundamentalMatrix(x1i, x2i); 
        F = Fh;
        num_inliers = 0;
        best_inliers_collector = zeros(num_pts,1);

        % Compute the Sampson error.

        for j=1:num_pts

            F1 = F*x1(:,j);
            F2 = F'*x2(:,j); 
            dist = abs(x2(:,j)'*F1 * ...
                (abs(1.0/sqrt(F1(1).^2+F1(2).^2)) + abs(1.0/sqrt(F2(1).^2+F2(2).^2))));
            
            if dist < threshold
                num_inliers = num_inliers + 1;
                best_inliers_collector(j) = 1;
            end
        end

        % Compute the inliers with errors smaller than the threshold.

        % Update the number of inliers and fitting model if the current model
        % is better.
        if num_inliers > best_num_inliers
            best_inliers = best_inliers_collector;
            best_num_inliers = num_inliers;
            best_F = F;
            
        end
        
        N = 8;
        M = i;
        r = best_num_inliers/num_pts;

        p = 1- (1-r^N)^M;

        if p > 0.99
            disp('M=')
            disp(i)

            break
        end
    end
    
    M
    best_num_inliers
    best_inliers = logical(best_inliers');
    F;

end


