% Generate initial values for the K
% covariance matrices

function cov = generate_cov(r_L, r_a, r_b, K)
    cov = zeros(3,3,K);
    for i = 1:K
        cov(:,:,i) = diag([r_L, r_a, r_b]);
    end
end