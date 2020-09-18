function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)

%check whether box is outside of image
xMin = round(max(1,xMin));
yMin = round(max(1,yMin));
xMax = round(min(xMax,size(frame,2)));
yMax = round(min(yMax,size(frame,1)));

red_frame = frame(yMin:yMax, xMin:xMax, 1 ) ;
green_frame = frame(yMin:yMax, xMin:xMax, 2 ) ;
blue_frame = frame(yMin:yMax, xMin:xMax, 3 ) ;

red_hist = imhist(red_frame,hist_bin) ;
green_hist = imhist(green_frame,hist_bin) ;
blue_hist = imhist(blue_frame,hist_bin) ;

hist = [red_hist ; green_hist ; blue_hist] ;
hist = hist/sum(hist); %this helps with cases where bounding box out of frame
