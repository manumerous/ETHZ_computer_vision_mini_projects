% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(Lmin, amin, bmin, rangeL, rangea, rangeb, K)

    mu = zeros(3,K) ;
    for i = 1:K
        l = Lmin + rangeL.*rand(1,1) ;
        a = amin + rangea.*rand(1,1) ;
        b = bmin + rangeb.*rand(1,1) ;
        mu(:,i) = [l ; a ; b];
    end
end