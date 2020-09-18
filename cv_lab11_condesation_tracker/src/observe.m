function particles_w = observe(particles,frame,H,W,hist_bin,hist_target,sigma_observe)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
N = max(size(particles)) ;
particles_weight = zeros(N,1) ;
hist_target = reshape(hist_target,1,3*hist_bin) ;

for i = 1:N
    xMin = particles(i,1) - W/2;
    xMax = particles(i,1) + W/2;
    yMin = particles(i,2) - H/2;
    yMax = particles(i,2) + H/2;
    particule_hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin);
    particule_hist = reshape(particule_hist,1,3*hist_bin);
    dist = chi2_cost(hist_target,particule_hist);
    
    %Calculate the weights according to the given formula
    particles_weight(i) = 1/(sqrt(2*pi)*sigma_observe)* ...
        exp(-(dist^2)/(2*sigma_observe^2));
end
%normalize
particles_w = particles_weight/sum(particles_weight);
end

