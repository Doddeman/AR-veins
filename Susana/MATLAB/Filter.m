
figure(1)
title('Butterworth/Gaussian Bandpass filter')
subplot(2,2,1)
imshow('jeppa.png');
xlabel('original');

%Butterworth filter:
micro = imread('jeppa.png'); %Matris 
fil_micro = butterworth(micro);
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

Im = imread('jeppa.png');
%Im = double(rgb2gray(Im1));
aver = [1 2 1; 2 4 2; 1 2 1]/16;
Imaver = conv2(Im, aver);
Image= uint8(Imaver);
subplot(2,2,3)
imshow(Image)
xlabel('Low pass filter')

% Low pass filter + Butterworth -->BRA!! NO HIGH PASS FILTER BAD!

figure(2)
picture = butterworth(Imaver);
imshow(picture)
%figure(3)
%imshow('jeppacut.png')

%{
figure(3)
paddedmatrix = padzeros(Imaver);
theimage = uint8(paddedmatrix);
imshow(theimage)

figure(4)
mesh(paddedmatrix)
%}

%Imadjust --> JEPPACUT


%Imad = imread('jeppacut.png');
Imad = picture;
%Imad1 = rgb2gray(Imad);
Jmad= imadjust(Imad);
figure(6)
imshow(Jmad)

smoothie = imgaussfilt(Jmad,2); %Imadjust + smoothie
figure(7)
imshow(smoothie);

%Binary --> DOES NOT WORK WELL 

level = graythresh(smoothie);
BW = imbinarize(smoothie, 0.7);

figure(8)
imshow(BW)
figure(9)
imshow(smoothie)






