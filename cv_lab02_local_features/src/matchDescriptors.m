% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)

    distances = ssd(descr1, descr2);
    
    if strcmp(matching, 'one-way')
        
        minMatrix = min(distances,[],2);
        [point1,point2] = find(distances==minMatrix);
        matches = [point1,point2]';        
        
    elseif strcmp(matching, 'mutual')
        
        
        minMatrix1 = min(distances,[],2);
        [point1,point2] = find(distances==minMatrix1);
        matches1 = [point1,point2]'; 
        
        minMatrix2 = min(distances,[],1);
        [point1,point2] = find(distances==minMatrix2);
        matches2 = [point1,point2]';
        
        matches = intersect(matches1', matches2', "rows")';
        
        
    elseif strcmp(matching, 'ratio')
        minMatrix = min(distances,[],2);
        [point1,point2] = find(distances==minMatrix);
        all_matches = [point1,point2]'; 
        minkMatrix = mink(distances,2,2);
        minkMatrix_ratio = minMatrix(:,1)./minkMatrix(:,2);
        ratio_points = find(minkMatrix_ratio<=0.5);
        
        matches = all_matches(:,ratio_points);
          
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)

    distances = pdist2(descr1',descr2','squaredeuclidean');
    
end