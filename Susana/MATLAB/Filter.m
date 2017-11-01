
%Butterworth filter:

micro = imread('jeppa.png'); %Matris 
micro = double(micro); 
[nx ny] = size(micro); 
u = micro; 
micro = uint8(u); 
imwrite(micro,'jeppa.png'); 
fftu = fft2(u,2*nx-1,2*ny-1); 
fftu = fftshift(fftu); 

figure(1)
title('Butterworth/Gaussian Bandpass filter')
subplot(2,2,1)
imshow('jeppa.png');
xlabel('original');

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
subplot(2,2,2) 
imshow(fil_micro,[])
xlabel('Butterworth bandpass filter')



% Gaussian Bandpass Filter

microG= imread('jeppa.png'); 
microG = double(microG);
[nx ny] = size(microG); 
u = microG; 
microG = uint8(u); 
imwrite(microG,'jeppa.png'); 
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
        % Use Gaussian filter. 
        filter1(i,j) = exp(-dist^2/(2*120^2)); 
        filter2(i,j) = exp(-dist^2/(2*30^2)); 
        filter3(i,j) = 1.0 - filter2(i,j); 
        filter3(i,j) = filter1(i,j).*filter3(i,j); 
    end 
end
 
% Update image with passed frequencies
 
fil_microG = fftu + filter3.*fftu; 
fil_microG = ifftshift(fil_microG); 
fil_microG = ifft2(fil_microG,2*nx-1,2*ny-1); 
fil_microG = real(fil_microG(1:nx,1:ny)); 
fil_microG = uint8(fil_microG); 
subplot(2,2,4)
imshow(fil_microG,[])
xlabel('Gaussian Bandpassfilter')


%Low pass filter

Im = double(imread('jeppa.png'));
aver = [1 2 1; 2 4 2; 1 2 1]/16;
Imaver = conv2(Im, aver,'same');
Image= uint8(Imaver);
subplot(2,2,3)
imshow(Image)
xlabel('Low pass filter')

% Low pass filter + Butterworth -->BRA!! NO HIGH PASS FILTER BAD!

picture = butterworth(Imaver);
figure(2)
imshow(picture)

figure(3)
mesh(Imaver)

figure(4)
paddedmatrix = padzeros(Imaver);
theimage = uint8(paddedmatrix);
imshow(theimage)

figure(5)
edgy = edge(theimage,'Prewitt', 0.009);
theedgyimage = uint8(edgy);
mesh(edgy)


[B,L,N] = bwboundaries(theimage);
imshow(theimage); hold on;
for k=1:length(B),
   boundary = B{k};
   if(k > N)
     plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
   else
     plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
   end
end


