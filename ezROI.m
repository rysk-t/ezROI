function varargout = ezROI(varargin)
% function varargout = ezROI()
%    varagout
%


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ezROI_OpeningFcn, ...
                   'gui_OutputFcn',  @ezROI_OutputFcn, ...
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

% --- Executes just before ezROI is made visible.
function ezROI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.ls = 0;
handles.hs = 1;

handles.cpos = [];
handles.cr   = [];
handles.c = [handles.cpos handles.cr];
%if varargin > 0
%	handles.img = varargin;
%else
	handles.img   = imread('coloredChips.png');
%end

if length(size(handles.img)) ==2
	disp('gray')
	img(:,:,1) = handles.img;
	img(:,:,2) = handles.img;
	img(:,:,3) = handles.img;
	handles.img = img;
end	
handles.RAW = handles.img;
handles.imgre = handles.img;

handles.crang   = [0.01 0.25]*size(handles.imgre, 1);
handles.cr      = int8(mean(handles.crang));
handles.crRange = 5;
handles.bg = uint8(zeros(size(handles.img)));
set(handles.rSld, 'Value', double(handles.crRange+4))
set(handles.rSld, 'Min', double(handles.crRange+1))
set(handles.rSld, 'Max', double(max(size(handles.img))*0.25));

imagesc(handles.img);	
axis image

guidata(hObject, handles);
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ezROI_OutputFcn(hObject, eventdata, handles)
out.imgre    = handles.img;
out.cr       = handles.cr;
out.cxyr     = get(handles.ROItab, 'data');
out.contrast = [handles.ls handles.hs];
% out.c
varargout{1} = out;
close

function imgrePlot(handles)
imagesc(handles.imgre);	
handles.imgre = double(handles.imgre);% - double(handles.bg);
axis image

function detectCircle(handles)
if get(handles.checkbox1, 'Value')
	[handles.cpos, handles.crs ] = imfindcircles(handles.imgre, ...
		int16(handles.cr) + [int16(-handles.crRange) int16(handles.crRange)], ...
		'ObjectPolarity', 'bright');
	[cposd, crsd ] = imfindcircles(handles.imgre, ...
		int16(handles.cr) + [int16(-handles.crRange) int16(handles.crRange)], ...
		'ObjectPolarity', 'dark');
	handles.cpos = [handles.cpos ; cposd];
	handles.crs  = [handles.crs  ; crsd ];
	imgrePlot(handles)
	viscircles(handles.cpos, handles.crs, ...
		'LineWidth', 2.5, 'EdgeColor', 'r')
	handles.c = [handles.cpos handles.crs];
	set(handles.ROItab, 'data', handles.c);
	set(handles.rlabel, 'String', ['r=' ...
		num2str(...
		int16(handles.cr)+[int16(-handles.crRange) int16(handles.crRange)])])

	hold off
else
end


% --- Executes on button press in Load_btn.
function Load_btn_Callback(hObject, eventdata, handles)
[fN, fPath] = uigetfile({'*.tif'; '*.tiff'; '*.png'}, 'File Selector');
handles.img = imread([fPath fN]);
handles.RAW = handles.img;
if length(size(handles.img)) ==2
	disp('gray')
	img(:,:,1) = handles.img;
	img(:,:,2) = handles.img;
	img(:,:,3) = handles.img;
	handles.img = img;
end	
handles.imgre = handles.img;
imgrePlot(handles);
detectCircle(handles)
guidata(hObject, handles);


% --- Executes on slider movement.
function imadSld_h_Callback(hObject, eventdata, handles)
handles.hs = get(hObject, 'value');
handles.imgre = imadjust(handles.img, [handles.ls, handles.hs]);
imgrePlot(handles);
detectCircle(handles)
guidata(hObject, handles);



function imadSld_h_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imadSld_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function imadSld_l_Callback(hObject, eventdata, handles)
handles.ls = get(hObject, 'value');
handles.imgre = imadjust(handles.img, [handles.ls, handles.hs]);
imgrePlot(handles);
detectCircle(handles)
guidata(hObject, handles);



function imadSld_l_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in fitCirc.
function fitCirc_Callback(hObject, eventdata, handles)
[handles.cpos, handles.crs ] = imfindcircles(handles.imgre, ...
	int16(handles.cr) + [int16(-handles.crRange) int16(handles.crRange)], ...
	'ObjectPolarity', 'bright');
[cposd, crsd ] = imfindcircles(handles.imgre, ...
	int16(handles.cr) + [int16(-handles.crRange) int16(handles.crRange)], ...
	'ObjectPolarity', 'dark');
handles.cpos = [handles.cpos ; cposd];
handles.crs  = [handles.crs  ; crsd ];
imgrePlot(handles)
viscircles(handles.cpos, handles.crs, 'LineWidth', 1)
handles.c = [handles.cpos handles.crs];
set(handles.ROItab, 'data', handles.c);
guidata(hObject, handles);
hold off



function rSld_Callback(hObject, eventdata, handles)
% hObject    handle to rSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.cr = get(hObject, 'Value');
detectCircle(handles)
guidata(hObject, handles);

function rSld_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rSld (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function rrange_Callback(hObject, eventdata, handles)
% hObject    handle to rrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rrange as text
%        str2double(get(hObject,'String')) returns contents of rrange as a double
handles.crRange = str2double(get(handles.rrange, 'String'));
set(handles.rSld, 'Value', double(handles.crRange+4))
set(handles.rSld, 'Min', double(handles.crRange+1))
set(handles.rSld, 'Max', double(max(size(handles.img))*0.25));
handles.crRange
detectCircle(handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function rrange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in exit_btn.
function varagout = exit_btn_Callback(hObject, eventdata, handles)
uiresume();


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bg_btn.
function bg_btn_Callback(hObject, eventdata, handles)
% hObject    handle to bg_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.bg = imopen(handles.img, strel('disk', 15));
imgrePlot(handles)
guidata(hObject, handles)
