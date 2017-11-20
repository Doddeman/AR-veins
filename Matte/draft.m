%mitt förslag 1

Originalet = imread('jeppacut.png');
Original = rgb2gray(Originalet);

A = adapthisteq(Original,'ClipLimit',0.015);

gaussian = imgaussfilt(A,2);

badlight = im2double(gaussian);

se = strel('diamond', 20);

%# Removes uneven lighting and enhances contrast.
lightok = imdivide(badlight,imclose(badlight,se));

figure(1)
subplot(2,2,1)
imshow(Original)
title('Original')
subplot(2,2,2)
imshow(A);
title('histeq')
subplot(2,2,3)
imshow(gaussian)
title('gaussian')
subplot(2,2,4)
imshow(lightok)
title('lightok')

contrasty = imadjust(lightok);

sep = strel('octagon',3);
close = imclose(contrasty,sep);

binary = imbinarize(close, 0.8);

invert = imcomplement(binary);

removespeckle = bwareaopen(invert, 1700);

figure(2)
subplot(2,3,1)
imshow(contrasty)
title('contrasty')
subplot(2,3,2)
imshow(close)
title('close')
subplot(2,3,3)
imshow(binary)
title('binary')
subplot(2,3,4)
imshow(invert)
title('invert')
subplot(2,3,5)
imshow(removespeckle)
title('removespeckle')
subplot(2,3,6)
imshow(removespeckle, [0 0 0; 1 0 0])
title('final result')

D = bwdist(~invert);
figure(4)
subplot(1,2,1)
imshow(D,[],'InitialMagnification','fit')
title('Distance transform')
subplot(1,2,2)
imshow((bwdist(~removespeckle)), [], 'InitialMagnification', 'fit')
BW2 = bwmorph(D,'skel',Inf);
BW3 = bwmorph(invert,'skel',Inf);

figure(5)
subplot(1,2,1)
imshow(BW3)
subplot(1,2,2)
imshow(medfilt2(BW3))

figure(6)
subplot(1,2,1)
imhist(uint8(Original), 128)
subplot(1,2,2)
imhist(uint8(A), 128)
