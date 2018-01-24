function varargout = mine(varargin)
% MINE MATLAB code for mine.fig
%      MINE, by itself, creates a new MINE or raises the existing
%      singleton*.
%
%      H = MINE returns the handle to a new MINE or the handle to
%      the existing singleton*.
%
%      MINE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MINE.M with the given input arguments.
%
%      MINE('Property','Value',...) creates a new MINE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mine_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mine_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mine

% Last Modified by GUIDE v2.5 24-Jan-2018 14:27:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mine_OpeningFcn, ...
                   'gui_OutputFcn',  @mine_OutputFcn, ...
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


% --- Executes just before mine is made visible.
function mine_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mine (see VARARGIN)

% Choose default command line output for mine
handles.output = hObject;
% handles.num=0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mine wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mine_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_in_Callback(hObject, eventdata, handles)
% hObject    handle to edit_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_in as text
%        str2double(get(hObject,'String')) returns contents of edit_in as a double
% handles.num = str2double(get(hObject,'String'));
% guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function edit_in_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_in (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');



function edit_out_Callback(hObject, eventdata, handles)
% hObject    handle to edit_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_out as text
%        str2double(get(hObject,'String')) returns contents of edit_out as a double


% --- Executes during object creation, after setting all properties.
function edit_out_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','0');



% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pstn=get(gcf,'CurrentPoint');
if pstn(1)>300
	set(gcf,'Pointer','hand');
else
	set(gcf,'Pointer','arrow');
end
set(handles.edit_in,'String',num2str(pstn(1)));
set(handles.edit_out,'String',num2str(pstn(2)));


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pstn=get(gcf,'CurrentPoint');
x=pstn(1);
y=pstn(2);
set(handles.edit_in,'String',num2str(x));
set(handles.edit_out,'String',num2str(y));
