Originalet = imread('jeppacut.png');
Original = rgb2gray(Originalet);

histeq = adapthisteq(Original,'ClipLimit',0.015);

gaussian = imgaussfilt(histeq,2);

badlight = im2double(gaussian);

se = strel('diamond', 20);

lightok = imdivide(badlight,imclose(badlight,se));

contrasty = imadjust(lightok);

sep = strel('octagon',3);

close = imclose(contrasty,sep);

binary = imbinarize(close, 0.8);

invert = imcomplement(binary);

removespeckle = bwareaopen(invert, 1700);

skeleton = bwmorph(invert,'skel', Inf);

figure(3)
imshow(skeleton)

octa = strel('octagon', 3);
fill = imdilate(skeleton,octa);
final = bwareaopen(fill, 800);

imshow(final, [1 1 1; 0 0 1])
