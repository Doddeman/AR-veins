function picture = pic_filter(pic)
image = imread(pic); %3D
image2 = rgb2gray(image); % 2D
A = adapthisteq(image2,'ClipLimit',0.015); % contrast
level = graythresh(A); % threshold value calculated to binarize the image
BA = imbinarize(A, 0.51);% Binarize the image 
median = medfilt2(BA); % Median filter 
% Fill any holes
fill = imfill(median, 'holes');
%Remove blobs that are smaller than X pixels across
se = strel('diamond', 10);
pic_end = imopen(fill, se);
figure(1);
subplot(2,2,1)
imshow(image);
subplot(2,2,2);
imshow(pic_end);
subplot(2,2,3);
imshow(pic_end, [0 0 0; 1 0 0]);
end




