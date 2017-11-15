function picture = pic_filter(pic)

A = adapthisteq(pic,'ClipLimit',0.015); % contrast
level = graythresh(A); % threshold value calculated to binarize the image
BA = imbinarize(A, 0.51);% Binarize the image 
median = medfilt2(BA); % Median filter 
% Fill any holes
fill = imfill(median, 'holes');
%Remove blobs that are smaller than X pixels across
se = strel('diamond', 10);
pic_end = imopen(fill, se);

picture = pic_end;

imshow(pic_end, [0 0 0; 1 0 0]);
end




