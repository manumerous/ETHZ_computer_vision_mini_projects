function vPoints = grid_points(img,nPointsX,nPointsY,border)

    [size_y, size_x] = size(img) ;   
    X = int32(linspace(1+border, size_x-border, nPointsX)) ;
    Y = int32(linspace(1+border, size_y-border, nPointsY)) ;
   
    [X,Y] = meshgrid(X,Y) ;
    X = reshape(X,nPointsX*nPointsY,1) ;
    Y = reshape(Y,nPointsY*nPointsX,1) ;
    vPoints = [X, Y] ;
    
end
