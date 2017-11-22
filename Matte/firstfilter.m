%mitt f�rslag 1

function result = firstfilter(image)

histeq = adapthisteq(image,'ClipLimit',0.015);
%result = histeq;

gaussian = imgaussfilt(histeq,2);
%result = gaussian;

badlight = im2double(gaussian);
%result = badlight;

se = strel('diamond', 20);

lightok = imdivide(badlight,imclose(badlight,se));
%result = lightok;

contrasty = imadjust(lightok);
%result = contrasty;

sep = strel('octagon',3);

close = imclose(contrasty,sep);
%result = close;

binary = imbinarize(close, 0.8);
result = binary;

invert = imcomplement(binary);
%result = invert;

removespeckle = bwareaopen(invert, 1700);
%result = removespeckle;

skeleton = bwmorph(removespeckle,'skel',Inf);
%result = skeleton;

octa = strel('octagon', 3);

fill = imdilate(skeleton,octa);
%result = fill;

final = bwareaopen(removespeckle, 800);

%result = removespeckle;

octa = strel('octagon', 3);
%octa2 = strel('octagon', 9);

skeleton = bwmorph(invert,'skel', Inf);

fill = imdilate(skeleton,octa);
final = bwareaopen(fill, 700);

imshow(final, [0 0 0; 0 1 0.97]);
end