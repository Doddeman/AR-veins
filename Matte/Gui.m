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
    
    % Last Modified by GUIDE v2.5 08-Nov-2017 11:04:59
    
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
    
    global vid
    global snapFrame
    global caseName

    snapFrame = handles.cameraAxesFrames;
%     vid = videoinput('pointgrey', 1, 'F7_Mono12_1288x964_Mode0');
     vid = videoinput('pointgrey', 1, 'F7_Mono8_1288x964_Mode0');
%     vid = videoinput('winvideo',1);
    
    handles.himage = image(zeros(720,1280,1), 'parent', handles.cameraAxes);
    %     handles.himage2 = image(zeros(720,1280,3), 'parent', handles.cameraAxesFrames);
    
    % vid.frameGrabInterval = 5;
    vid.FramesPerTrigger = inf;
    
    % Go on forever until stopped
    set(vid,'TriggerRepeat',Inf);
    triggerconfig(vid,'manual')
%     vid.ReturnedColorSpace = rgb;
    
    start(vid)
    
    preview(vid, handles.himage);

    caseName = 'default';
    while isrunning(vid)
        frame=uint8(getsnapshot(vid));
        pause(0.2) % 5 fps
%         frame = rgb2gray(frame);
        
        switch caseName
            case 'gaussian'
                frame =  imgaussfilt(frame, 2);
            case 'derivative'
                [~,frame] = imgradientxy(frame);
            case 'greenFilter'
                frame = ind2rgb(gray2ind(frame,255),summer(255)); 
            case 'redFilter'
                frame = ind2rgb(gray2ind(frame,255),autumn(255));
            case 'contrast'
                
                

%                 frame = adapthisteq(frame);

                 frame = histeq(frame); %fan rätt bra
                 frame = imadjust(frame, [0 1],[0 0.7]);
                 frame =  imgaussfilt(frame, 2);
%                    frame = ind2rgb(gray2ind(frame,255),autumn(255));
            case 'default'
                
                
                %   frame = ind2rgb(gray2ind(frame,255),jet(255));
                %     frame = ind2rgb(gray2ind(frame,255),summer(255)); %GREEN
                %RED
                
                % imshow(rgbImage);
                
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
    
    
    
    % function timerFunc(hObject, eventdata, handles)
    %     global vid
    %     global snapFrame
    %     global timerWind
    %
    %     set(timerWind, 'String', num2str(get(hObject,'TasksExecuted')));
    %     frame=uint8(getsnapshot(vid));
    %     frame = rgb2gray(frame);
    %
    %     imshow(frame, 'Parent', snapFrame)
    
    
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
    global caseName
    val = get(hObject,'Value')
    
    if val == 1
        caseName = 'derivative'
    else
        caseName = 'default';
    end
    
    % --- Executes on button press in contrastCheck.
function contrastCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to contrastCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of contrastCheck
        global caseName
    val = get(hObject,'Value')
    
    if val == 1
        caseName = 'contrast'
    else
        caseName = 'default';
    end
    
    
    
    
    % --- Executes on button press in redCheck.
function redCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to redCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of redCheck
    global caseName
    val = get(hObject,'Value')
    
    if val == 1
        caseName = 'redFilter'
    else
        caseName = 'default';
    end
    
    
    % --- Executes on button press in greenCheck.
function greenCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to greenCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of greenCheck
    global caseName
    val = get(hObject,'Value')
    
    if val == 1
        caseName = 'greenFilter'
    else
        caseName = 'default';
    end
    
    
    % --- Executes when user attempts to close Gui.
function Gui_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to Gui (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: delete(hObject) closes the figure
    
    global vid
    stop(vid);
    
    delete(hObject);
