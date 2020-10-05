function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(0,nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(0,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
    
%     for i = [1:size(vPoints,1)] % for all local feature points
%         m=1 ;
%         %iterate through descriptors:
%         for j =1:nCellsW
%             for k =1:nCellsH
%                 x_range = vPoints(i,1)+(-nCellsW*0.5+j-1)*w:vPoints(i,1)+(-nCellsW*0.5+j)*w-1;
%                 y_range = vPoints(i,2)+(-nCellsH*0.5+k-1)*h:vPoints(i,2)+(-nCellsH*0.5+k)*h-1;
%                 
%                 patch = img(y_range,x_range); 
%                 grad_of_patch = Gdir(y_range,x_range);
%                 
%                 descriptors(i,m:m+7) = histcounts(grad_of_patch,nBins,'BinLimits',[-pi,pi]);          
%                 m = m+8 ;
%             end
%         end
%         %add overall patch to patches
%         patches(i,:) = reshape( ...
%                     img((vPoints(i,2)-(nCellsH/2)*h):(vPoints(i,2)+ (nCellsH/2)*h-1), ...
%                             (vPoints(i,1)-(nCellsW/2) *w):(vPoints(i,1)+(nCellsW/2)*w-1)) ,1,w*h*4*4) ;
%     end % for all local feature points
    
    for i = [1:size(vPoints,1)] % for all local feature points
        m=1 ;
        n=1 ;
        for j = -2:1
            for k = -2:1
                patch = img((vPoints(i,2)+k*h):(vPoints(i,2)+(k+1)*h-1), ...
                            (vPoints(i,1)+j*w):(vPoints(i,1)+(j+1)*w-1)); 
                patch_orientation = Gdir( ...
                                (vPoints(i,2)+k*h):(vPoints(i,2)+(k+1)*h-1), ...
                                (vPoints(i,1)+j*w):(vPoints(i,1)+(j+1)*w-1)) ;
                descriptors(i,m:m+7) = histcounts(patch_orientation, ...
                                                nBins,'BinLimits',[-pi,pi]);          
                m = m+8 ;
            end
        end
        patches(i,:) = reshape( ...
                    img((vPoints(i,2)-2*h):(vPoints(i,2)+ 2*h-1), ...
                            (vPoints(i,1)-2 *w):(vPoints(i,1)+2*w-1)) ,1,w*h*4*4) ;
        
    end % for all local feature points
    
end
