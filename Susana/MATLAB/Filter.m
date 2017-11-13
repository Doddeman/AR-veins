
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

Im1= imread('jeppacut.png');
Im = double(rgb2gray(Im1));
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

figure(10)
jeppacut= imread('jeppacut.png');
jc = rgb2gray(jeppacut);
A = adapthisteq(jc,'ClipLimit',0.015);
imshow(A)
%% BÄSTA HITTILLS -> SUSANA
level = graythresh(A);
BA = imbinarize(A, 0.51);
BAN = 1  - BA;
figure(11)
imshow(BAN)

figure(13)
median = medfilt2(BA);
imshow(median)

figure(12)
imshow(median, [0 0 0; 1 0 0])

figure(14)
SE = [1 1 1 1 ; 1 1 1 1; 1 1 1 1];
IM2 = imerode(BAN,SE); %Kan ej beräknas storleken på den bilden pga att den tar bort lite av venerna 
imshow(IM2)  

%figure(15)
%imshow(IM3,[0 0 0; 1 0 0])    %%VARFÖR FUNKAR INTE??

%%
%Remove noise
figure(16)
subplot(2,2,1);
imshow(median);

%Fill any holes
fill = imfill(median, 'holes');
figure(16)
subplot(2,2,2);
imshow(fill)


%Remove blobs that are smaller than X pixels across

se = strel('disk', 10);
open = imopen(fill, se);
subplot(2,2,3);
imshow(open);

subplot (2,2,4);
imshow(A)

%Measure Object Diameter 

diameter = regionprops(open,'MajorAxisLength');

figure(17)
imshow(open)
d= imdistline; 

