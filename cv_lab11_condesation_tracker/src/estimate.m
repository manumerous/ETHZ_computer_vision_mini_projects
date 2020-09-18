function meanState = estimate(particles,particles_w) 

meanState = sum(particles.*particles_w,1) ;