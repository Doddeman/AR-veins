%mitt förslag 1

function result = firstfilter(image)

median = medfilt2(image);

ball = offsetstrel('ball',3,3);
eroded = imerode(median,ball);

gaussian = imgaussfilt(eroded,1);

badlight = im2double(gaussian);

se = strel('diamond', 15);

lightok = imdivide(badlight,imclose(badlight,se));

contrasty = imadjust(lightok);

sep = strel('octagon',3);
close = imclose(contrasty,sep);

binary = imbinarize(close, 0.95);

invert = imcomplement(binary);

removespeckle = bwareaopen(invert, 1000);

result = gaussian;

%imshow(removespeckle, [1 1 1; 0 0 1]);
end