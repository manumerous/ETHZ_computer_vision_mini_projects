function L = gcDisparity(imgL, imgR, dispRange)

    imgL = im2single(imgL);
    imgR = im2single(imgR);

    %Data Cost
    Dc = diffsGC(imgL, imgR, dispRange);
    
    %smoothness cost
    k = size(Dc,3);
    Sc = ones(k) - eye(k);
    

    % size of sigma filter might still be needed to tune
    [Hc Vc] = gradient(imfilter(imgL,fspecial('gauss',[3 3]),'symmetric'));

    gch = GraphCut('open', 500*Dc, 7*Sc, exp(-Vc*5), exp(-Hc*5));

    [gch L] = GraphCut('expand',gch);
    gch = GraphCut('close', gch);
end
