%sobel
figure(1)
Original = double(imread('jeppa.png'));
sobelX = [1 0 -1; 2 0 -2; 1 0 -1]/0.01;
SobelXimage = conv2(Original, sobelX);
sobelY = [-1 -2 -1; 0 0 0; 1 2 1]/4;
SobelXYimage = conv2(SobelXimage, sobelY);
Image= uint8(SobelXYimage);
imshow(Image)
xlabel('Sobel-x filter')

figure(2)
imshow('jeppa.png');

picture = butterworth(Imaver);

figure(3)
I = imread('jeppa.png');
BW1 = edge(I,'Canny');
imshow(BW1)