cam = webcam(1);

while true
    img = snapshot(cam);
    grey = rgb2gray(img);
%     B = imresize(img,[964 1288 1]);
    aver = [1 2 1; 2 4 2; 1 2 1]/16;
    Imaver = conv2(grey, aver);
    Image = uint8(Imaver);
    B = imresize(Image,[480 640]);
    figure(1)
    imshow(B);
%     image(B);
    xlabel('Low pass filter')
    
    pause(0.2);
end

clear cam
