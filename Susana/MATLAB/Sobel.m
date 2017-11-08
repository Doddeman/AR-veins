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

I = imread('jeppacut.png');
Ig = rgb2gray(I);
aver = [1 2 1; 2 4 2; 1 2 1]/16;
Igl = conv2(Ig, aver);
Iglb = butterworth(Igl);
Image = uint8(Iglb);

figure(1)
subplot(2,2,1)
imshow('jeppa.png')
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


figure(13)
mesh(Image)
figure(14)
mesh(final)

level = graythresh(Fy);
binary = imbinarize(Fy, 1);

figure(14)
imshow(binary)

medianbinary = medfilt2(binary, [4,4]);

figure(15)
subplot(2,2,1)
imshow(binary, [1 1 1; 1 0 0])
subplot(2,2,2)
imshow(binary, [0 0 0; 1 0 0])
subplot(2,2,3)
imshow(medianbinary)
subplot(2,2,4)
imshow(medianbinary, [0 0 0; 1 0 0])

figure(89)
pic = imgaussfilt(double(binary), 6);
imshow(pic)



%remove bad light
background = imopen(pic,strel('disk',100));

figure(188)
surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
set(gca,'ydir','reverse');

figure(27)
I2 = pic - background;
imshow(I2)

figure(80)
level = graythresh(pic);
hej = imbinarize(I2, 0.2);

imshow(hej)

