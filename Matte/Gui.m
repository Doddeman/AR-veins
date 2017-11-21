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
    
    % Last Modified by GUIDE v2.5 21-Nov-2017 13:42:41
    
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
    global frame
    global keyPressed
    global KEY_IS_PRESSED
    
    set(gcf,'toolbar','figure');
    snapFrame = handles.cameraAxesFrames;
    %          vid = videoinput('pointgrey', 1, 'F7_Mono8_1288x964_Mode0');
    vid = videoinput('winvideo',1);
    
    handles.himage = image(zeros(720,1280,3), 'Parent', handles.cameraAxesFrames);
    
    % vid.frameGrabInterval = 5;
    vid.FramesPerTrigger = inf;
    
    % Go on forever until stopped
    set(vid,'TriggerRepeat',Inf);
    triggerconfig(vid,'manual')
    
    start(vid)
    preview(vid, handles.himage);

    posVec = get(handles.cameraAxesFrames, 'Position');

    while isrunning(vid)

        frame=uint8(getsnapshot(vid));
        frame = rgb2gray(frame);
        %% Filter
        if (get(handles.redCheck, 'Value') == 1)
            frame = ind2rgb(gray2ind(frame,255),autumn(255));
            set(handles.greenCheck, 'Value', 0);
        end
        
        if (get(handles.greenCheck, 'Value') == 1)
            frame = ind2rgb(gray2ind(frame,255), summer(255));
            set(handles.redCheck, 'Value', 0);
        end
        
        if (get(handles.gaussCheck, 'Value') == 1)
            frame =  imgaussfilt(frame, 2);
        end
        
        if (get(handles.derCheck, 'Value') == 1)
            [~,frame] = imgradientxy(frame);
        end
        
        if (get(handles.contrastCheck, 'Value') == 1)
            frame = histeq(frame); %fan rätt bra
            frame = imadjust(frame, [0 1],[0 0.7]);
            frame =  imgaussfilt(frame, 2);  
        end
        
        %% Flytta runt bilden på d, a, w och s
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'d'))           
            posVec(1) = posVec(1) + 0.02;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'a'))
            posVec(1) = posVec(1) - 0.02;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'w'))
            posVec(2) = posVec(2) + 0.02;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'s'))
            posVec(2) = posVec(2) - 0.02;
        end
      
        %% Ändra storlek på bild med z och x
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'z'))
            posVec(1) = posVec(1)+0.02*0.5;
            posVec(2) = posVec(2)+0.02*0.5;
            posVec(3) = posVec(3)-0.02;
            posVec(4) = posVec(4)-0.02;
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'x'))
            posVec(1) = posVec(1)-0.02*0.5;
            posVec(2) = posVec(2)-0.02*0.5;
            posVec(3) = posVec(3)+0.02;
            posVec(4) = posVec(4)+0.02;
        end
        
        set(handles.cameraAxesFrames, 'outerposition', posVec)
        
        %% Zoom
        zoomVar = 1+5*get(handles.slider2, 'value');
        zoom(zoomVar);
        
        %% Fps
        pause(0.1) % fps
        
        %% Display
        imshow(frame, 'Parent', snapFrame);
        
        
        
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
    
    % --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
    % hObject    handle to stopButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global vid
    start(vid);
    
    
    
    % --- Executes on button press in gaussCheck.
function gaussCheck_Callback(hObject, eventdata, handles)
    % hObject    handle to gaussCheck (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hint: get(hObject,'Value') returns toggle state of gaussCheck
    
    % --- Executes on button press in derCheck.
function derCheck_Callback(hObject, eventdata, handles)
    
    
    % --- Executes on button press in contrastCheck.
function contrastCheck_Callback(hObject, eventdata, handles)
    
    % --- Executes on button press in redCheck.
function redCheck_Callback(hObject, eventdata, handles)
    
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
    % global keyRelease
    % determine the key that was pressed
    %  global keyPressed
    %  keyRelease = eventdata.Key;
    KEY_IS_PRESSED = 0;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
