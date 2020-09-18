function diffs = diffsGC(img1, img2, dispRange)

total_range = dispRange(end) - dispRange(1) ;
filter_window_size = 7 ;
diffs = zeros(size(img1,1), size(img1,2) ,total_range) ;

for i = 0:total_range
    img2_shift = shiftImage( img2, i-ceil(total_range/2) ) ;
    %using SSD
    diffs(:,:,i+1) = (img1 - img2_shift).^2 ;
    
    box_filter = fspecial('average',filter_window_size) ;
    diffs(:,:,i+1) = conv2( diffs(:,:,i+1), box_filter,'same') ;  
end

end