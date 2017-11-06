function varargout = Gui(varargin)
    % GUI MATLAB code for Gui.fig
    %      GUI, by itself, creates a new GUI or raises the existing
    %      singleton*.
    %
    %      H = GUI returns the handle to a new GUI or the handle to
    %      the existing singleton*.
    %
    %      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in GUI.M with the given input arguments.
    %
    %      GUI('Property','Value',...) creates a new GUI or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before Gui_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to Gui_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help Gui
    
    % Last Modified by GUIDE v2.5 06-Nov-2017 17:07:38
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @Gui_OpeningFcn, ...
        'gui_OutputFcn',  @Gui_OutputFcn, ...
        'gui_LayoutFcn',  [] , ...
        'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end
    
    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT
    
    
    % --- Executes just before Gui is made visible.
function Gui_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to Gui (see VARARGIN)
    
    % Choose default command line output for Gui
    handles.output = hObject;
    
    % handles.vid = videoinput('pointgrey', 1, 'F7_Mono12_1288x964_Mode0');
    global vid
    % global himage2
    global snapFrame
    global timerWind
    global caseName
    
    timerWind = handles.timerWind;
    snapFrame = handles.cameraAxesFrames;
    vid = videoinput('winvideo',1);
    
    handles.himage = image(zeros(720,1280,3), 'parent', handles.cameraAxes);
    %     handles.himage2 = image(zeros(720,1280,3), 'parent', handles.cameraAxesFrames);
    
    % vid.frameGrabInterval = 5;
    vid.FramesPerTrigger = inf;
    % Go on forever until stopped
    set(vid,'TriggerRepeat',Inf);
    triggerconfig(vid,'manual')
    start(vid)
    %
    preview(vid, handles.himage);
    
    %     timer1 = timer(...
    %         'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly.
    %         'Period', 3, ...                        % Initial period is 1 sec.
    %         'TimerFcn', {@timerFunc, hObject}); % @(src,event) TmrFcn(src,event,gcf,s)
    %     start(timer1);
    
    % updateFrame(hObject, eventdata, handles)
      caseName = 'default';
    
    while isrunning(vid)
        frame=uint8(getsnapshot(vid));
        pause(0.2)
        
        frame = rgb2gray(frame);
      
        switch caseName
            case 'gaussian'
                frame =  imgaussfilt(frame, 2);
            case 'derivative'
                [gx,frame] = imgradientxy(frame);
              imshow(frame, 'Parent', snapFrame)
            case 'default'

                
        end
        imshow(frame, 'Parent', snapFrame)
        %         Imaver = conv2(frame, aver);     
        %         frame = butterworth(Imaver);
        % frame = filter(B,A,frame);
        %       frame = conv2(frame, boxKernel, 'same');
%         imshow(frame, 'Parent', snapFrame)
    end
    
    
    % Update handles structure
    guidata(hObject, handles);
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = Gui_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    % handles.output = hObject;
    
    varargout{1} = handles.himage;
    
    
    
function timerFunc(hObject, eventdata, handles)
    global vid
    global snapFrame
    global timerWind
    
    set(timerWind, 'String', num2str(get(hObject,'TasksExecuted')));
    frame=uint8(getsnapshot(vid));
    frame = rgb2gray(frame);
    
    
    
    aver = [1 2 1; 2 4 2; 1 2 1]/16;
    Imaver = conv2(frame, aver);
    
    frame = butterworth(Imaver);
    imshow(frame, 'Parent', snapFrame)
    
    
    %Butterworth filter:
function BW = butterworth (immatris)
    
    micro = double(immatris);
    u = micro;
    [nx ny] = size(micro);
    fftu = fft2(u,2*nx-1,2*ny-1);
    fftu = fftshift(fftu);
    
    % Initialize filter.
    filter1 = ones(2*nx-1,2*ny-1);
    filter2 = ones(2*nx-1,2*ny-1);
    filter3 = ones(2*nx-1,2*ny-1);
    n = 4;
    for i = 1:2*nx-1
        for j =1:2*ny-1
            dist = ((i-(nx+1))^2 + (j-(ny+1))^2)^.5;
            
            % Use Butterworth filter.
            filter1(i,j)= 1/(1 + (dist/120)^(2*n));
            filter2(i,j) = 1/(1 + (dist/30)^(2*n));
            filter3(i,j)= 1.0 - filter2(i,j);
            filter3(i,j) = filter1(i,j).*filter3(i,j);
        end
        
    end
    
    % Update image with passed frequencies.
    
    fil_micro1 = fftu + filter3.*fftu;
    fil_micro2 = ifftshift(fil_micro1);
    fil_micro3 = ifft2(fil_micro2,2*nx-1,2*ny-1);
    fil_micro4 = real(fil_micro3(1:nx,1:ny));
    fil_micro = uint8(fil_micro4);
    BW= fil_micro;
    
    
    
    
    
    
    % --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
    % hObject    handle to stopButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global vid
    stop(vid);
    
    
    % --- Executes on button press in gaussCheck.
function gaussCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to gaussCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of gaussCheck
    global caseName
     val = get(hObject,'Value');
     if val == 1
     caseName = 'gaussian';
     else
         caseName = 'default';
     end
     
    
    % --- Executes on button press in derCheck.
function derCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to derCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of derCheck
     val = get(hObject,'Value')
     global caseName
     
          if val == 1
     caseName = 'derivative'
     else
         caseName = 'default';
     end
    
    % --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
    % hObject    handle to checkbox3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of checkbox3
