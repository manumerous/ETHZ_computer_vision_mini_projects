function [I_grad_x, I_grad_y] = calculateGradients(img)
%CALCULATEGRADIENTS takes an Array of Image Intensity Pixels and calculates
%the gradient in x and y direction

gradX_kernel = [0.5,0,-0.5];
gradY_kernel = gradX_kernel';

I_grad_x = conv2(img, gradX_kernel,'same');
I_grad_y = conv2(img, gradY_kernel,'same');

%montage({img,I_grad_x,I_grad_y});
end

