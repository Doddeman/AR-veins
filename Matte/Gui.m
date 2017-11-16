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
    
    % Last Modified by GUIDE v2.5 15-Nov-2017 09:43:58
    
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
    global i
    global j
    global KEY_IS_PRESSED
    
    
    j = 50;
    i = 50;
    
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
    
    r= 0;
    c= 0;
    co=0;
    ro=0;
%     padDirr = 'pre';
    
    
    while isrunning(vid)
        
        frame=uint8(getsnapshot(vid));
        prePad = [c r];
%         postPad = [co ro];
        
        
        frame = rgb2gray(frame);
        
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
        
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'rightarrow'))
            %             i = i+20;
            r = r +20;
            % if ro >20
            %     ro = ro-20;
            % end
            
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'leftarrow'))
            %             i = i+20;
            r = r -20;
            % if r>20
            % r = r-20;
            % end
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'uparrow'))
            %             j = j+20;
            % c = c +20;
            c = c+20;
            
        end
        if (KEY_IS_PRESSED == 1 && strcmpi(keyPressed,'downarrow'))
            %             j = j+20;
            c = c -20;
            
        end
        
        pause(0.5) %  fps
        
        %         if (strcmpi(keyPressed,'rightarrow'))
        %             padSize = [abs(c-co) abs(r-ro)]
        %             cropRect = [1 1 size(frame,2)-abs(r-ro)-1 size(frame,1)-c-1];
        %             frame = imcrop(frame, cropRect);
        %             if r >= ro
        %                 frame = padarray(frame, padSize,1, 'pre');
        %             else
        %                 frame = padarray(frame, padSize,1, 'post');
        %             end
        %
        %         end
        %         if (strcmpi(keyPressed,'leftarrow'))
        %             padSize = [abs(c-co) abs(r-ro)]
        %             cropRect = [abs(r-ro) 1 size(frame,2)-(1) size(frame,1)-1];
        %             frame = imcrop(frame, cropRect);
        %             if r >= ro
        %                 frame = padarray(frame, padSize,1, 'pre');
        %             else
        %                 frame = padarray(frame, padSize,1, 'post');
        %             end
        %         end
        %
        %         if (strcmpi(keyPressed,'uparrow'))
        %             frame = imcrop(frame, [ro co 1280-r 720-c]);
        %             frame = padarray(frame, prePad,1, 'pre');
        %             frame = padarray(frame, postPad,1, 'post');
        %             (size(frame))
        %         end
        %
        %         if (strcmpi(keyPressed,'downarrow'))
        %             frame = imcrop(frame, [ro co 1280-r 720-c]);
        %             frame = padarray(frame, prePad,1, 'pre');
        %             frame = padarray(frame, postPad,1, 'post');
        %             (size(frame))
        %         end
        
        
        if (strcmpi(keyPressed,'rightarrow'))
            cropRect = [ro co 1280-(abs(r)) 720-c]
            if(r<0)
                cropRect = [abs(r) co 1280 720-c]
                padDirr = 'post';
            else
                padDirr = 'pre';
            end          
            frame = imcrop(frame, cropRect);
            frame = padarray(frame, abs(prePad),1, padDirr);
            (size(frame))
        end
        
        if (strcmpi(keyPressed,'leftarrow'))
            cropRect = [ro co 1280-(abs(r)) 720-c]           
            if (r<0)
                cropRect = [abs(r) co 1280 720-c]
                padDirr = 'post';
            else
                padDirr = 'pre';
            end           
            frame = imcrop(frame, cropRect);
            frame = padarray(frame, abs(prePad),1, padDirr);
            (size(frame))
        end
        
        if (strcmpi(keyPressed,'uparrow'))
%             cropRect = [ro co 1280-(abs(r)) 720]           
%             if (c<0)
%                 cropRect = [abs(r) abs(c) 1280 720]
%                 padDirr = 'post';
%             else
%                 padDirr = 'pre';
%             end     
%             frame = imcrop(frame, cropRect);
%             frame = padarray(frame, abs(prePad),1, padDirr);
%             (size(frame))
        end
        
        if (strcmpi(keyPressed,'downarrow'))
%             cropRect = [ro co 1280-(abs(r)) 720]           
%             if (c<0)
%                 cropRect = [abs(r) c 1280 720-c]
%                 padDirr = 'post';
%             else
%                 padDirr = 'pre';
%             end     
%             frame = imcrop(frame, cropRect);
%             frame = padarray(frame, abs(prePad),1, padDirr);
%             (size(frame))
        end
        
        
        
        
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
