%Butterworth filter:
function BW = butterworth (immatris)

micro = double(immatris); 
u = micro; 
[nx ny] = size(micro); 
fftu = fft2(u,2*nx-1,2*ny-1); 
fftu = fftshift(fftu); 

% Initialize filter. 
filter1 = ones(2*nx-1,2*ny-1); 
filter2 = ones(2*nx-1,2*ny-1); 
filter3 = ones(2*nx-1,2*ny-1); 
n = 4; 
for i = 1:2*nx-1 
    for j =1:2*ny-1 
        dist = ((i-(nx+1))^2 + (j-(ny+1))^2)^.5; 
        
        % Use Butterworth filter. 
        filter1(i,j)= 1/(1 + (dist/120)^(2*n)); 
        filter2(i,j) = 1/(1 + (dist/30)^(2*n)); 
        filter3(i,j)= 1.0 - filter2(i,j); 
        filter3(i,j) = filter1(i,j).*filter3(i,j); 
    end
 
end
 
% Update image with passed frequencies.
 
fil_micro1 = fftu + filter3.*fftu; 
fil_micro2 = ifftshift(fil_micro1); 
fil_micro3 = ifft2(fil_micro2,2*nx-1,2*ny-1); 
fil_micro4 = real(fil_micro3(1:nx,1:ny)); 
fil_micro = uint8(fil_micro4); 
BW= fil_micro;



