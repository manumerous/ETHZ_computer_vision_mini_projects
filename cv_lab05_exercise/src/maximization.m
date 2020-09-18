function [mu, var, alpha] = maximization(P, X)

K = size(P,2) ;
N = size(X,2) ;
alpha = zeros(1,K) ;
mu = zeros(3,K) ;
var = zeros(3,3,K) ;

for k = 1:K
    probability_sum = 0 ;
    covar = zeros(3,3) ;
    
    probability_sum = sum(P(:,k)) ;
    alpha(1,k) = probability_sum/N ;
    mu(:,k) = sum(X.*repmat(P(:,k)',[3,1]),2) ;
    mu(:,k) = mu(:,k)/ probability_sum ;
    diff = X - repmat(mu(:,k),[1,N]) ;
    for n = 1:N
        covar = covar + P(n,k)*(diff(:,n)*diff(:,n)') ;
    end
    var(:,:,k) = covar./ probability_sum ;
end
    
end