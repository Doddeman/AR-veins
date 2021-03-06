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
    
    % Last Modified by GUIDE v2.5 29-Nov-2017 10:20:50
    
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
    global keyPressed
    global KEY_IS_PRESSED
    global frame
    
    KEY_IS_PRESSED = 0;
    
    set(gcf, 'toolbar', 'none');
    snapFrame = handles.cameraAxesFrames;
    %     vid = videoinput('pointgrey', 1, 'F7_Mono8_1288x964_Mode0');
    
    %WEBCAM
    vid = videoinput('winvideo',1);
    %     handles.himage = image(zeros(720,1280,3), 'Parent', handles.cameraAxesFrames);
    
    handles.himage = image(zeros(964,1288,3), 'Parent', handles.cameraAxesFrames);
    
    vid.FramesPerTrigger = inf;
    
    % Go on forever until stopped
    set(vid,'TriggerRepeat',Inf);
    triggerconfig(vid,'manual')
    
    start(vid)
    preview(vid, handles.himage);
    
    % Inital alignment variables
    posVec = [0.3104 0.1121 0.5892 0.6384];
    zoomVar = 2.05;
    
    set(handles.greenCheck,'Visible','off');
    set(handles.turqCheck,'Visible','off');
    set(handles.binCheck,'Visible','off');
    set(handles.lightCheck,'Visible','off');
    set(handles.histeqCheck,'Visible','off');
    set(handles.invCheck,'Visible','off');
    set(handles.binSlider,'Visible','off');
    set(handles.histeqSlider,'Visible','off');
    set(handles.speckSlider,'Visible','off');
    set(handles.thresText,'Visible','off');
    set(handles.speckText,'Visible','off');
    set(handles.skelCheck,'Visible','off');
    
    se = strel('diamond', 20);
    sep = strel('octagon',3);
    
    
    while isrunning(vid)
        t = tic;
        
        frame=uint8(getsnapshot(vid));
        
        % Webcam, can be removed later
        if size(frame, 3) == 3
            frame = rgb2gray(frame);
        end
        frame=im2double(frame);
        
        dim = size(frame);
        croprect = [300 400 dim(2)-330 dim(1)-130]; % for pointgray
        
        frame = imcrop(frame, [croprect(1:2), ...
            croprect(3:4) - croprect(1:2)]);
        
        dim =size(frame);
        set(handles.cameraAxesFrames,'xlim',[1 dim(2)],'ylim',[1 dim(1)]);
        
        %% Filter
        if (get(handles.histeqCheck, 'Value') == 1)
            
            frame = adapthisteq(frame, 'ClipLimit', get(handles.histeqSlider, 'Value'));
            frame =  imgaussfilt(frame, 2);
        end
        
        if (get(handles.lightCheck, 'Value') == 1)
            frame =  imdivide(frame, imclose(frame, se));
        end
        
        if (get(handles.binCheck, 'Value') == 1)
            frame = imadjust(frame);
            frame = imclose(frame,sep);
            frame = imbinarize(frame, get(handles.binSlider, 'Value'));
            frame = imcomplement(frame);
            frame = im2double(bwareaopen(frame, round(2000*get(handles.speckSlider, 'Value'))));
        end
        
        if (get(handles.skelCheck, 'Value') == 1)
            frame =  bwmorph(frame,'skel',round(1*get(handles.skel_slider, 'Value')));
        end
        
        if (get(handles.greenCheck, 'Value') == 1)
            frame=uint8(frame);
            frame = ind2rgb(frame, [0 0 0; 0 1 0]);
            set(handles.turqCheck, 'Value', 0);
        end
        
        if (get(handles.turqCheck, 'Value') == 1)
            frame=uint8(frame);
            frame = ind2rgb(frame, [0 0 0; 0 1 0.97]);
            set(handles.greenCheck, 'Value', 0);
        end
        
        if (get(handles.invCheck, 'Value') == 1)
            frame = imcomplement(frame);
            set(handles.turqCheck, 'string', 'Red');
            set(handles.greenCheck, 'string', 'Pink');
        end
        
        if (get(handles.invCheck, 'Value') == 0)
            set(handles.turqCheck, 'string', 'Turquoise');
            set(handles.greenCheck, 'string', 'Green');
        end
        %% Move image with d, a, w och s
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'d'))
            posVec(1) = posVec(1) + 0.005;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'a'))
            posVec(1) = posVec(1) - 0.005;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'w'))
            posVec(2) = posVec(2) + 0.005;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'s'))
            posVec(2) = posVec(2) - 0.005;
        end
        
        %% Change size of image with z och x
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'v'))
            posVec(1) = posVec(1)+0.005*0.5;
            posVec(2) = posVec(2)+0.005*0.5;
            posVec(3) = posVec(3)-0.005;
            posVec(4) = posVec(4)-0.005;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'c'))
            posVec(1) = posVec(1)-0.005*0.5;
            posVec(2) = posVec(2)-0.005*0.5;
            posVec(3) = posVec(3)+0.005;
            posVec(4) = posVec(4)+0.005;
        end
        set(handles.cameraAxesFrames, 'outerposition', posVec)
        
        %% Zoom in and out
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'x'))
            zoomVar = zoomVar - 0.02;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'z'))
            zoomVar = zoomVar + 0.02;
        end
        
        zoom(zoomVar);
        pause(0.1) % "fps"
        
        %% Display
        imshow(frame, 'Parent', snapFrame);
        
        %% Show FPS
        fps = round(1./toc(t), 1);
        set(handles.fpsText, 'String', num2str(fps));
        
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
    %% Callbacks
    % --- Outputs from this function are returned to the command line.
function varargout = Gui_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    % handles.output = hObject;
    
    varargout{1} = handles.himage;
    
function lightCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to lightCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % Hint: get(hObject,'Value') returns toggle state of lightCheck
    
    % --- Executes on button press in binCheck.
function binCheck_Callback(hObject, eventdata, handles)
    
    % --- Executes on button press in turqCheck.
function turqCheck_Callback(hObject, eventdata, handles)
    
    % --- Executes on button press in greenCheck.
function greenCheck_Callback(hObject, eventdata, handles)
    
    % --- Executes when user attempts to close Gui.
function Gui_CloseRequestFcn(hObject, eventdata, handles)
    % hObject    handle to Gui (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: delete(hObject) closes the figure
    
    global vid
    stop(vid);
    delete(hObject);
    
    % --- Executes during object creation, after setting all properties.
function cameraAxesFrames_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to cameraAxesFrames (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    % surf(handles.cameraAxesFrames);
    % Hint: place code in OpeningFcn to populate cameraAxesFrames
    
    % --- Executes on key press with focus on Gui or any of its controls.
function Gui_WindowKeyPressFcn(hObject, eventdata, handles)
    % hObject    handle to Gui (see GCBO)
    % eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
    %	Key: name of the key that was pressed, in lower case
    %	Character: character interpretation of the key(s) that was pressed
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
    % handles    structure with handles and user data (see GUIDATA)
    
    global keyPressed
    global KEY_IS_PRESSED
    keyPressed = eventdata.Key;
    KEY_IS_PRESSED = 1;
    
    % --- Executes on key release with focus on Gui or any of its controls.
function Gui_WindowKeyReleaseFcn(hObject, eventdata, handles)
    % hObject    handle to Gui (see GCBO)
    % eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
    %	Key: name of the key that was released, in lower case
    %	Character: character interpretation of the key(s) that was released
    %	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
    % handles    structure with handles and user data (see GUIDATA)
    
    global KEY_IS_PRESSED
    KEY_IS_PRESSED = 0;
    
    % --- Executes on button press in tech_button.
function tech_button_Callback(hObject, eventdata, handles)
    % hObject    handle to tech_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    answer = inputdlg('Enter Password:')
    if (strcmp(answer, '1111'))
        set(handles.greenCheck,'Visible','on');
        set(handles.turqCheck,'Visible','on');
        set(handles.binCheck,'Visible','on');
        set(handles.lightCheck,'Visible','on');
        set(handles.histeqCheck,'Visible','on');
        set(handles.binSlider,'Visible','on');
        set(handles.histeqSlider,'Visible','on');
        set(handles.speckSlider,'Visible','on');
        set(handles.thresText,'Visible','on');
        set(handles.speckText,'Visible','on');
        set(handles.invCheck,'Visible','on');
        set(handles.skelCheck,'Visible','on');
        set(handles.skel_slider,'Visible','on');
    end
    
    % --- Executes on button press in clin_button.
function clin_button_Callback(hObject, eventdata, handles)
    % hObject    handle to clin_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    set(handles.greenCheck,'Visible','off');
    set(handles.turqCheck,'Visible','off');
    set(handles.binCheck,'Visible','off');
    set(handles.lightCheck,'Visible','off');
    set(handles.histeqCheck,'Visible','off');
    set(handles.histeqSlider,'Visible','off');
    set(handles.binSlider,'Visible','off');
    set(handles.speckSlider,'Visible','off');
    set(handles.thresText,'Visible','off');
    set(handles.speckText,'Visible','off');
    set(handles.invCheck,'Visible','off');
    set(handles.skelCheck,'Visible','off');
    set(handles.skel_slider,'Visible','off');
    
    % --- Executes on button press in histeqCheck.
function histeqCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to histeqCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of histeqCheck
    
    
    % --- Executes on button press in snap_button.
function snap_button_Callback(hObject, eventdata, handles)
    % hObject    handle to snap_button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    global frame
    imageName = datestr(now, 'mmmm-dd HH-MM-SS');
    path =strcat(pwd, '\Images')
    if exist(path, 'dir')
        
        path = strcat(pwd, '\Images\', imageName ,'.png')
        imwrite(frame, path);
    else
        mkdir Images
        path = strcat(pwd, '\Images\', imageName ,'.png')
        imwrite(frame, path);
    end
    
    
    
    
    % --- Executes on slider movement.
function binSlider_Callback(hObject, eventdata, handles)
    % hObject    handle to binSlider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    % --- Executes during object creation, after setting all properties.
function binSlider_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to binSlider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    % --- Executes on slider movement.
function histeqSlider_Callback(hObject, eventdata, handles)
    % hObject    handle to histeqSlider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    % --- Executes during object creation, after setting all properties.
function histeqSlider_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to histeqSlider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    % --- Executes on slider movement.
function speckSlider_Callback(hObject, eventdata, handles)
    % hObject    handle to speckSlider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    
    % --- Executes during object creation, after setting all properties.
function speckSlider_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to speckSlider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
    
    % --- Executes on button press in invCheck.
function invCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to invCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of invCheck
    
    
    % --- Executes on button press in skelCheck.
function skelCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to skelCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of skelCheck
    
    
    % --- Executes on slider movement.
function skel_slider_Callback(hObject, eventdata, handles)
    % hObject    handle to skel_slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: get(hObject,'Value') returns position of slider
    %        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    
    % --- Executes during object creation, after setting all properties.
function skel_slider_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to skel_slider (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
