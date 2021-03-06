cam = videoinput('pointgrey', 1, 'F7_Mono8_644x482_Mode1');
src = getselectedsource(cam);

while true %infinite loop
%     src.Brightness = 7.42;
    img = getsnapshot(cam);
    aver = [1 2 1; 2 4 2; 1 2 1]/16;
    Imaver = conv2(img, aver);
    Image = uint8(Imaver);
    B = imresize(Image,[480 640]);
    B = imadjust(B,[0.3; 0.6],[0.0;1.0]);
    figure(1)
    imshow(B);
%     image(B); % blue and yellow
    xlabel('Low pass filter')
    pause(0.2); %5 frames per second 
end

% clear cam
