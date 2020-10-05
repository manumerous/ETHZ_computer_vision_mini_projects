function [d] = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)

%function inputs:

% X = set of points
% nbBins_theta = number of bins in angular dimension
% nbBins_r = number of bins in radial dimension
% smallest_r = the smallest radius 
% biggest_r = the biggest radius 

X = X' ;

normalization_factor = mean2(sqrt(dist2(X,X))) ;  
smallest_r = smallest_r*normalization_factor ;
biggest_r = biggest_r*normalization_factor ;
delta_r(1) = smallest_r ;
theta_size = 360/nbBins_theta ;

for i = 1:nbBins_r
    delta_r(i+1) =  exp(log(smallest_r) + (log(biggest_r) - log(smallest_r))*i/nbBins_r) ;
end
%  delta_r/normalization

d = zeros(max(size(X)), theta_size*nbBins_r) ;
for i = 1:size(X,1)
    for j = 1:size(X,1)
        r = norm(X(i,:)-X(j,:)) ;
        if  (r < biggest_r && r > smallest_r)
            deltax = X(j,1) - X(i,1) ;
            deltay = X(j,2) - X(i,2) ;
            theta = rad2deg(atan2 (deltay,deltax)) ;
            if theta<0
                theta = 360 + theta ;
            end
            theta_idx = ceil(theta/nbBins_theta) ;
            if theta_idx == 0 %avoid 0 index
                theta_idx = 1 ;
            end
            r_idx = max(find(r >= delta_r)) ;
            % vector embedding
            d(i,theta_idx + (r_idx-1)*theta_size) = ...
                                        d(i,theta_idx + (r_idx-1)*theta_size) +1 ; 
        end
    end
end



end
