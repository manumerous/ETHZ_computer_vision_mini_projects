function [map peak] = meanshiftSeg(img)

%% creat the distribution X
L = size(img,2)*size(img,1) ;
l = (reshape(img(:,:,1), 1,L)) ;
a = (reshape(img(:,:,2), 1,L)) ;
b = (reshape(img(:,:,3), 1,L)) ;
X = [l;a;b] ;
%I need to normalize the points, This will amke it much easier to chose
%threshold parameters (adapt function from HW1)
Xh = [X ; ones(1,L)] ;
size(Xh) ;
Xh = double(Xh) ;

map = zeros(1,L); %initiate a map of the right size
peak = [] ;

%% go through all pixels and look for clusters
radius =5 ; % I will have to tune this parameter
threshhold = radius/2 ;

 for i = 1:L %project tips fo not do loops ... I start witha loop and evaluate performances
     mean_1pt = find_peak(Xh(1:3,i),Xh(1:3,:),radius) ;
     if i==1 %first run
         peak = mean_1pt ;
         map(i) = 1 ;
         fprintf('Begining of Mean Shift (update every 2500 pixels) \n') ;
         fprintf('Peak number %d detected \n',size(peak,2)) ;
     else
         % distance with existing peaks
        dist = sqrt(sum(((peak-repmat(mean_1pt,[1,size(peak,2)])).^2)));
        idx = find(dist < threshhold,1);
        if(idx>=1)
            map(i) = idx;            
        else
            peak = [peak mean_1pt];
            map(i) = size(peak,2);
            fprintf('Peak number %d detected \n',size(peak,2)) ;
        end
     end
        
    if mod(i,2500) == 0
        fprintf(int2str(i)) ;
        fprintf(' pixels treated out of ')
        fprintf(int2str(L))
        fprintf('\n')
    end

 end
 
 map = reshape(map, size(img,1), size(img,2));
 peak = peak(1:3,1:end)';
end