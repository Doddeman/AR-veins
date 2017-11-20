%mitt förslag 1

function result = firstfilter(image)
% 
% se = strel('disk',5);
% 
% hairs = imbothat(image,se);
% BW = hairs > 15;
% 
% BW2 = imdilate(BW,strel('disk',2));
% 
% 
% 
% replacedImage = roifill(image,BW2);
% 
% result = replacedImage;

histeq = adapthisteq(image,'ClipLimit',0.015);

gaussian = imgaussfilt(histeq,2);

badlight = im2double(gaussian);

se = strel('diamond', 15);

lightok = imdivide(badlight,imclose(badlight,se));

contrasty = imadjust(lightok);

sep = strel('octagon',3);
close = imclose(contrasty,sep);

binary = imbinarize(close, 0.95);

invert = imcomplement(binary);

removespeckle = bwareaopen(invert, 2000);

   result = removespeckle;

imshow(removespeckle, [1 1 1; 0 0 1]);

water = bwdist(~invert);

imshow(water,[],'InitialMagnification','fit');

g = imgaussfilt(water, 1);

removespeckle2 = bwareaopen(g, 1000);

imshow(removespeckle2)
end