vid = videoinput('pointgrey', 1, 'F7_Mono8_1288x964_Mode0');
% src = getselectedsource(vid);



vid.FramesPerTrigger = 1;

% preview(vid);


frame = getsnapshot(vid);
image(frame);


% start(vid);

% 

% stoppreview(vid);