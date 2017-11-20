
Originalet = imread('grey_hair.jpg');
Original = rgb2gray(Originalet);

I = rgb2gray(imread('grey_hair.jpg'));

contrast = imadjust(I);

se = strel('disk',5);

hairs = imbothat(I,se);
BW = hairs > 15;

BW2 = imdilate(BW,strel('disk',2));



replacedImage = roifill(I,BW2);

figure(2)
subplot(1,2,1)
imshow(I)
subplot(1,2,2)
imshow(replacedImage)

ll = edge (replacedImage,'canny');

figure(3)
imshow(ll)

figure(1)
subplot(3,3,1)
imshow(Original)
subplot(3,3,2)
imshow(contrast)
subplot(3,3,3)
imshow(hairs)
subplot(3,3,4)
imshow(BW)
subplot(3,3,5)
imshow(BW2)
subplot(3,3,6)
imshow(replacedImage)
subplot(3,3,9)
imshow(ll)
