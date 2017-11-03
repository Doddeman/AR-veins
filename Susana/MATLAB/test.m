Im1 = imread('jeppapaint.png');
Im = double(rgb2gray(Im1));
%smooth = imgaussfilt(Im,1);
aver = [1 2 1; 2 4 2; 1 2 1]/16;
Imaver = conv2(Im, aver);
sharpy = imsharpen(Imaver);
paddedmatrix = padzeros(sharpy);
Image= uint8(paddedmatrix);
%picture = butterworth(Imaver);

figure(1)
imshow(Image) 

figure(2)
mesh(paddedmatrix)

ix = find(imregionalmax(z));
hold on
plot3(x(ix),y(ix),z(ix),'r*')


