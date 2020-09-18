%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function

% 1. For each correspondence xi <-> Xi, computes matrix Ai
A = [];
num_points = length(xyn(1,:));
for i = 1:num_points
    A = [A; -XYZn(:,i)' zeros(1,4) xyn(1,i)*XYZn(:,i)';
        zeros(1,4) -XYZn(:,i)' xyn(2,i)*XYZn(:,i)'];
end

% 2. Compute the Singular Value Decomposition of A
[U,S,V] = svd(A);

% 3. Compute P_normalized (=last column of V if D = matrix with positive
% diagonal entries arranged in descending order)
P_normalized = (reshape(V(:,end),[4,3]))';

end
