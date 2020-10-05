function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked
filter_window_size = 19 ; %values to try: 3x3, 5x5, 7x7

% convert values to doubles for calculations
img1 = double(img1) ;
img2 = double(img2) ;

for i = dispRange

    %shift the image horizontally with distance d
    img2_shifted = shiftImage( img2, i ) ;
    %using SSD to calculate difference between pixels
    diff_img = (img1 - img2_shifted).^2 ;
    average_filter = fspecial('average',filter_window_size) ;
    diff_img_filtered = imfilter(diff_img, average_filter,'replicate'); 
    
    %first iteration of loop:s
    if i == dispRange(1)
        bestDiff =diff_img_filtered;
        %set the picture matrix to in this case -40 in every element
        disp = i*ones(size(diff_img_filtered)) ;
    % all other irerations:
    else
        % contains 1 in the points where the current difference is better
        distance_improved =diff_img_filtered< bestDiff;
        distance_improved_inv =diff_img_filtered>= bestDiff ;
        % set current distance where better than previous distance 
        disp = disp.*distance_improved_inv + i.*distance_improved ;
        bestDiff = bestDiff.*distance_improved_inv +diff_img_filtered.*distance_improved ;
    end
end  
disp;
end