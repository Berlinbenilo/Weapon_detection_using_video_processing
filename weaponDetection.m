function varargout = weaponDetection(varargin)
%WEAPONDETECTION MATLAB code file for weaponDetection.fig
%      WEAPONDETECTION, by itself, creates a new WEAPONDETECTION or raises the existing
%      singleton*.
%
%      H = WEAPONDETECTION returns the handle to a new WEAPONDETECTION or the handle to
%      the existing singleton*.
%
%      WEAPONDETECTION('Property','Value',...) creates a new WEAPONDETECTION using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to weaponDetection_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WEAPONDETECTION('CALLBACK') and WEAPONDETECTION('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WEAPONDETECTION.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help weaponDetection

% Last Modified by GUIDE v2.5 07-Dec-2019 12:40:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @weaponDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @weaponDetection_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before weaponDetection is made visible.
function weaponDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for weaponDetection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes weaponDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = weaponDetection_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load('DetectorKnife.mat');
load('DetectorGun.mat');
A = uigetfile('fileSelector','fileExtention','.mp4');
vidReader = VideoReader(A);

vidPlayer = vision.DeployableVideoPlayer;
i = 1;
results = struct('Boxes',[],'scores',[]);
result = struct('Box',[],'score',[]);


while(hasFrame(vidReader))
    I = readFrame(vidReader);
%     image(I,'Parent',axes);
%     set(axes,'visible','off');
    pause(1/vidReader.FrameRate)
    [bboxes,scores] = detect(detectorKnife,I,'threshold',1);
        [bbox,score] = detect(detectorGun,I,'threshold',1);

   
    [~,idx] = max(scores);
    
    results(i).Boxes = bboxes;
    results(i).Scores = scores;
    
    [~,ids] = max(score);
    results(i).Box = bbox;
    results(i).Score = score;
    
    annotation = sprintf('%s, Confidence %.2f',detectorKnife.ModelName,scores(idx));
    I = insertObjectAnnotation(I,'rectangle',bboxes(idx,:),annotation);
    
    Annotation = sprintf('%s, Confidence %4.2f',detectorGun.ModelName,score(ids));
    I = insertObjectAnnotation(I,'rectangle',bbox(ids,:),Annotation);

    axes=handles.axes1;

    step(vidPlayer,I);
    step(axes,I);
%   if(score(ids)>=80)
%         fprintf('gun detected\n');
%   end
%   if(scores(idx)>=80)
%         fprintf('knife detected\n');
%   end
    i = i+1;
end
results = struct2table(results);

result = struct2table(result);

release(axes);


