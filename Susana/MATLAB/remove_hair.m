function output = remove_hair(image)
I = rgb2gray(imread('david_hair1.png'));
%I = imread('David.png');


se = strel('disk',6);
hairs = imbothat(I,se);
BW = hairs > 15; 
BW2 = imdilate(BW,strel('disk',3));
figure(1)
subplot(1,2,1)
imshow(BW)
subplot(1,2,2)
imshow(BW2)
replacedImage = roifill(I,BW2);
figure(2)
subplot(1,2,1)
imshow(I)
subplot(1,2,2)
imshow(replacedImage)
ll = edge (replacedImage,'canny');
%figure(3)
%imshow(ll)
end