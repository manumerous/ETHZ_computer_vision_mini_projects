function particles = propagate(particles,sizeFrame,params)

%Calculatew position and velocity noise
%1. zero mean, 2. sigma, 3. vector legth, 
pos_noise = normrnd(0,params.sigma_position,2,params.num_particles);
vel_noise = normrnd(0,params.sigma_velocity,2,params.num_particles);

particles = particles' ; %(2 lines, particle_number columns)

if(params.model==0)
    %no velocity model => Velocities have no influence on position
    A = eye(2) ;
    particles = (A*particles + pos_noise);
     
else
    %constant velocity model 
    A = [1, 0, 1, 0;
         0, 1, 0, 1;
         0, 0, 1, 0;
         0, 0, 0, 1];   
     particles = A*particles +  [pos_noise ; vel_noise];
end

%%

%%Adust particles that are outside the frame
particles(1,:) = min(particles(1,:),sizeFrame(2)); % max y position
particles(1,:) = max(particles(1,:),1); %min y position
particles(2,:) = min(particles(2,:),sizeFrame(1)); %max x position
particles(2,:) = max(particles(2,:),1); %min x position

particles = particles' ; %(2 columns, particle_number lines)
