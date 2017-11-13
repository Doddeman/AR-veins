%mitt förslag 1
Originalet = imread('jeppacut.png');
Original = rgb2gray(Originalet);

kernel = [1 2 1; 2 4 2; 1 2 1]/16;
LP = conv2(Original, kernel);

median = medfilt2(uint8(LP));

ball = offsetstrel('ball',3,3);
eroded = imerode(median,ball);

sep = strel('octagon',3);
close = imclose(median,sep);

gaussian = imgaussfilt(eroded,1);

badlight = im2double(gaussian);

%# Any large (relative to objects) structuring element will do.
%# Try sizes up to about half of the image size.
se = strel('diamond', 15);

%# Removes uneven lighting and enhances contrast.
lightok = imdivide(badlight,imclose(badlight,se));

figure(2)
subplot(1,2,1)
imshow(lightok)

contrasty = imadjust(lightok);
closer = imclose(contrasty,sep);

figure(3)
subplot(1,2,1)
imshow(contrasty)
subplot(1,2,2)
imshow(closer)

gauzzy = imgaussfilt(contrasty, 6);

figure(4)
subplot(1,2,1)
imshow(gauzzy)
subplot(1,2,2)
imshow(closer)

contrasty2 = imadjust(gauzzy);

figure(5)
subplot(1,2,1)
imshow(contrasty2)
subplot(1,2,2)
imshow(closer)

hej =removegrey(contrasty);

figure(6)
subplot(1,2,1)
imshow(hej)
subplot(1,2,2)
imshow(closer)

binaryyy = imbinarize(hej, 0.9);
closer1 = imbinarize(closer, 0.95);

figure(7)
subplot(1,2,1)
imshow(binaryyy)
subplot(1,2,2)
imshow(closer1)

invert = imcomplement(binaryyy);
invert2 = imcomplement(closer1);

figure(8)
subplot(1,2,1)
imshow(invert)
subplot(1,2,2)
imshow(invert2)

removespeckle = bwareaopen(invert, 900);
removespeckle2 = bwareaopen(invert2, 900);

figure(9)
subplot(1,2,1)
imshow(removespeckle)
subplot(1,2,2)
imshow(removespeckle2)

hellu = medfilt2(removespeckle);

final = hellu + removespeckle2;


figure(10)
subplot(2,2,1)
imshow(Original)
subplot(2,2,2)
imshow(hellu, [1 1 1; 0 0 1])
subplot(2,2,3)
imshow(removespeckle2, [1 1 1; 0 0 1])
subplot(2,2,4)
imshow(final)%, [1 1 1; 0 0 1])

