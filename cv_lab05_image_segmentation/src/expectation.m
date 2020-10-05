function P = expectation(mu,var,alpha,X)
% This function calculates the expectation based on the parameters mu, var, alpha and X

K = length(alpha);
N = size(X,2) ;
P = double(zeros(N,K));

% loop through
for n = 1:N   
    for k = 1:K
        P(n,k) = alpha(k)/((2*pi)^(3/2)*(det(var(:,:,k)))^(1/2))*...
                 exp(-0.5 .*...
                 (X(:,n)-mu(:,k))'*...
                 inv((var(:,:,k)))*...
                 (X(:,n)-mu(:,k)));
    end 
    % scale expectation value
    P(n,:) = P(n,:)/sum(P(n,:));
end

end