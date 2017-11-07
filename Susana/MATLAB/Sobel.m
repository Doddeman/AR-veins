%sobel
% figure(1)
% Original = double(imread('jeppa.png'));
% sobelX = [1 0 -1; 2 0 -2; 1 0 -1]/0.01;
% SobelXimage = conv2(Original, sobelX);
% sobelY = [-1 -2 -1; 0 0 0; 1 2 1]/4;
% SobelXYimage = conv2(SobelXimage, sobelY);
% Image= uint8(SobelXYimage);
% imshow(Image)
% xlabel('Sobel-x filter')

Ig = imread('jeppa.png');
%Ig = rgb2gray(I);
aver = [1 2 1; 2 4 2; 1 2 1]/16;
Igl = conv2(Ig, aver);
Iglb = butterworth(Igl);
Image = uint8(Iglb);

figure(1)
subplot(2,2,1)
imshow('jeppacut.png')
subplot(2,2,2)
imshow(Image)

figure(5)
contrast = imadjust(Image);
imshow(contrast)

figure(6)
smoothie = imgaussfilt(contrast,1);
imshow(smoothie)

figure(7)
median = medfilt2(Image);
imshow(median)

figure(8)
median = medfilt2(contrast);
imshow(median)

figure(9)
median = medfilt2(smoothie);
imshow(median)

final = padzeros(Image);


[Gx, Gy] = imgradientxy(smoothie, 'sobel');
[Fx, Fy] = imgradientxy(smoothie, 'central');
[Px, Py] = imgradientxy(smoothie, 'prewitt');
[Rx, Ry] = imgradientxy(smoothie, 'intermediate');

figure(11)
subplot(1,2,1)
imshow(Ry)
title('intermediate')
subplot(1, 2, 2)
imshow(Fy)
title('central')

figure(12)
nohole = imfill(Fy,'holes');
imshow(nohole)

figure(13)
mesh(Image)
figure(14)
mesh(final)

level = graythresh(Fy);
binary = imbinarize(Fy, 1);

figure(14)
imshow(binary)

figure(15)
subplot(2,2,1)
imshow(binary, [1 1 1; 1 0 0])
subplot(2,2,2)
imshow(binary, [0 0 0; 1 0 0])
subplot(2,2,3)

