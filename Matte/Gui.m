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

% Last Modified by GUIDE v2.5 03-Nov-2017 15:53:53

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

handles.vid = videoinput('winvideo',1);
handles.himage = image(zeros(720,1280,3), 'parent', handles.cameraAxes);
handles.himage2 = image(zeros(720,1280,3), 'parent', handles.cameraAxesFrames);

handles.vid.frameGrabInterval = 5;
handles.video.FramesPerTrigger = inf;
% Go on forever until stopped
set(handles.vid,'TriggerRepeat',Inf);

% TIMER
timer1 = timer(...
    'ExecutionMode', 'fixedRate', ...       % Run timer repeatedly.
    'Period', 0.2, ...                        % Initial period is 1 sec.
    'TimerFcn', {@timerFunc, hObject});
start(timer1);




preview(handles.vid, handles.himage);

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
varargout{1} = handles.output;



% --- Executes on button press in grayScale.
function grayScale_Callback(hObject, eventdata, handles)
% hObject    handle to grayScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get a grayscale image
% global vid himage;

set(handles.vid,'ReturnedColorSpace','grayscale')

   
function timerFunc(hObject, eventdata, handles)
handles = guihandles(handles);
set(handles.timerWind, 'String', num2str(get(hObject,'TasksExecuted')));
% updateFrame(hObject, eventdata, handles)


function updateFrame(hObject, eventdata, handles)
frame=uint8(getsnapshot(handles.vid));
axes(handles.cameraAxesFrames);
frame = rgb2gray(frame);
imshow(frame);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% frame = getsnapshot(handles.vid);
frame=uint8(getsnapshot(handles.vid));

axes(handles.cameraAxesFrames)
imshow(frame);

% frame = uint8(frame);
% imshow(butterworth(frame(:,:,2)));
% disp(size(frame))
% surf(double(rgb2hsv(frame)));
% surf(rgb2hsv(frame));
% colormap summer
% preview(handles.vid, handles.himage);
% set(vid,'ReturnedColorSpace',h)
% vid
