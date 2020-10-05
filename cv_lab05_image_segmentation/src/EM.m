function [map cluster] = EM(img)

%% creat the distribution X
width = size(img,2) ; height = size(img,1) ;
L = width*height ;
l = (reshape(img(:,:,1), 1,L)) ;
a = (reshape(img(:,:,2), 1,L)) ;
b = (reshape(img(:,:,3), 1,L)) ;
X = [l;a;b] ;

Xh = [X ; ones(1,L)] ;

% generate the parameters
%number of clusters 
K = 3 ;
% initialization of alpha (see slides)
alpha = ones(1,K)/K;

% Find ranges of values in L*a*b space
Lmax = max(Xh(:,1)); Lmin = min(Xh(:,1)); rangeL = Lmax - Lmin ;
amax = max(Xh(:,2)); amin = min(Xh(:,2)); rangea = amax - amin ;
bmax = max(Xh(:,3)); bmin = min(Xh(:,3)); rangeb = bmax - bmin ;
% use function generate_mu to initialize mus
mu = generate_mu(Lmin, amin, bmin, rangeL, rangea, rangeb, K);
% figure ; 
% histogram(mu(3,:),5)
% use function generate_cov to initialize covariances
var = generate_cov(rangeL, rangea, rangeb, K) ;

% iterate between maximization and expectation
tol = 1; 
deltaMu = tol+1 ;
iter = 0 ;
while deltaMu > tol;
    iter = iter+1 ;
    fprintf('I have performed %d iterations of EM already\n', iter);
    

    % calculate function expectation
    Xh = double(Xh);
    P = expectation(mu,var,alpha,Xh(1:3,:));
    % calculatefunction maximization
    [mu1, var1, alpha1] = maximization(P, Xh(1:3,:));
    deltaMu = norm(mu(:)-mu1(:));
    mu = mu1; 
    var = var1;
    alpha = alpha1;
% %   ids = visualizeMostLikelySegments(Xn,alpha_s,mu_s,var_s);
end

mu
var
alpha
[~,label_idx] = max(P,[],2) ;
map = reshape(label_idx ,height, width) ;
cluster = mu';
cluster = cluster(1:3,:)';


end