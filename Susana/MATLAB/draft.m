%mitt förslag 1

function result = filter(image)

Originalet = imread(image);
Original = rgb2gray(Originalet);

median = medfilt2(uint8(Original));

ball = offsetstrel('ball',3,3);
eroded = imerode(median,ball);

gaussian = imgaussfilt(eroded,1);

badlight = im2double(gaussian);

%# Any large (relative to objects) structuring element will do.
%# Try sizes up to about half of the image size.
se = strel('diamond', 15);

%# Removes uneven lighting and enhances contrast.
lightok = imdivide(badlight,imclose(badlight,se));

figure(1)
subplot(2,3,1)
imshow(Original)
title('Original')
subplot(2,3,2)

title('LP')
subplot(2,3,3)
imshow(median)
title('median')
subplot(2,3,4)
imshow(eroded)
title('eroded')
subplot(2,3,5)
imshow(gaussian)
title('gaussian')
subplot(2,3,6)
imshow(badlight)
title('badlight')

contrasty = imadjust(lightok);

sep = strel('octagon',3);
close = imclose(contrasty,sep);

binary = imbinarize(close, 0.95);

invert = imcomplement(binary);

removespeckle = bwareaopen(invert, 1000);

figure(2)
subplot(2,3,1)
imshow(Original)
title('Original')
subplot(2,3,2)
title('LP')
subplot(2,5,3)
imshow(median)
title('median')
subplot(2,3,4)
imshow(eroded)
title('eroded')
subplot(2,3,5)
imshow(gaussian)
title('gaussian')
subplot(2,3,6)
imshow(badlight)
title('badlight')
subplot(2,3,1)
imshow(lightok)
title('lightok')
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
imshow(removespeckle, [1 1 1; 0 0 1])
title('final result')



