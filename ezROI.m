function varargout = ezROI(varargin)
% EZROI MATLAB code for ezROI.fig
%      EZROI, by itself, creates a new EZROI or raises the existing
%      singleton*.
%
%      H = EZROI returns the handle to a new EZROI or the handle to
%      the existing singleton*.
%
%      EZROI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EZROI.M with the given input arguments.
%
%      EZROI('Property','Value',...) creates a new EZROI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ezROI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ezROI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ezROI

% Last Modified by GUIDE v2.5 27-Sep-2015 05:50:13

% Begin initialization code - DO NOT EDIT
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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ezROI (see VARARGIN)

% Choose default command line output for ezROI
handles.revice_btn.Value = false;

handles.Ctype = [];
handles.output = hObject;
handles.roitable.Data = [0 0];
handles.cSize = 10;
handles.cIdx = 0;

handles.color = ~colorcube(9);
set(gca, 'YTick', []);
set(gca, 'XTick', []);

if length(varargin) == 0;
	handles.bw = {};
	handles.img = double(imread('example.png'));
	handles.img = handles.img./max(handles.img(:));
else
	ROI = varargin{:};
	handles.img = ROI{1};
	handles.bw = ROI{2};
	handles.Ctype = ROI{3};
end
	
handles.RAW = handles.img;
handles.show = handles.img;
if length(size(handles.img)) > 2
	handles.img = mean(handles.img,3);
end
imagesc(handles.RAW); hold on
colormap gray
plotRegions(hObject, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ezROI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ezROI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if ~isempty(handles.Ctype);
	ROI.RAW = handles.RAW;
	ROI.bw = handles.bw;
	ROI.Ctype = handles.Ctype;
	handles.output = ROI;
	varargout{1} = handles.output;
	assignin('base', 'ROI', ROI);
end

% --- Executes on button press in import_btn.
function import_btn_Callback(hObject, eventdata, handles)
% hObject    handle to import_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fp, c] = uigetimagefile;
handles.img = double(imread(fp));
handles.img = handles.img./max(handles.img(:));
handles.RAW = handles.img;
handles.show = handles.img;
if length(size(handles.img)) > 2
	handles.img = mean(handles.img,3);
end
imagesc(handles.RAW); hold on
colormap gray
guidata(hObject, handles);


% --- Executes on button press in export_btn.
function export_btn_Callback(hObject, eventdata, handles)
% hObject    handle to export_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ezROI_OutputFcn(hObject, eventdata, handles);

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles: structure with handles and user data (see GUIDATA)??
eventdata.Key

if eventdata.Key==('z')
	handles.bw(handles.cIdx) = [];
	if handles.cIdx == 0;
		handles.cIdx =1;
	else
		handles.cIdx =handles.cIdx -1; 
	end
elseif eventdata.Key==('r')
	handles.revice_btn.Value = ~handles.revice_btn.Value;
elseif eventdata.Key==('d')	
	handles.bw(handles.cIdx) = [];
	x = find(cellfun('isempty', handles.bw));
	handles.c
	handles.bw(x) = [];
	handles.cIdx = length(handles.bw);
elseif strfind('123456789', eventdata.Key)
	handles.Ctype(handles.cIdx) = str2double(eventdata.Key);
end
plotRegions(hObject, handles)
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get(0,'PointerLocation')
if handles.cIdx == 0
	handles.cIdx = 1;
end
if handles.revice_btn.Value == true
else
	handles.cIdx = length(handles.bw)+1;
end

imgadapt = handles.show;
if length(size(handles.show))==3
	imgadapt = mean(handles.show, 3);
end

pos = round(get(handles.axes1,'CurrentPoint'));
pos = [pos(1,1) pos(1,2)];

mask = zeros(size(handles.img));
mask(pos(2)+(-handles.cSize:handles.cSize),...
	pos(1)+(-handles.cSize:handles.cSize)) = 1;
maskd = activecontour(imgadapt, mask, 16, 'edge', 0.8);
bw = bwboundaries(maskd);
bw = bw{1};
handles.Ctype(handles.cIdx) = 1;
handles.bw{handles.cIdx} = bw;
plotRegions(hObject, handles)
guidata(hObject, handles);


function plotRegions(hObject, handles)
cla
imagesc(handles.show, [0 1]);
hold on; axis image;
handles.roitable.Data = [0 0];
for i = 1:length(handles.bw)	
	plot(handles.bw{i}(:,2), handles.bw{i}(:,1), ...
		'Color', handles.color(handles.Ctype(i),:));
	handles.roitable.Data(i,1) = round(mean(handles.bw{i}(:,2)));
	handles.roitable.Data(i,2) = round(mean(handles.bw{i}(:,1)));
	handles.roitable.Data(i,3) = handles.Ctype(i);
end
if handles.checkbox3.Value ==1
	showIDs(handles);
end

guidata(hObject, handles);


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
eventdata.VerticalScrollCount
maskd = poly2mask(handles.bw{handles.cIdx}(:,2),...
	handles.bw{handles.cIdx}(:,1),...
	size(handles.img, 1), size(handles.img, 2));
if eventdata.VerticalScrollCount < 0
se = strel('disk', 1); 
erodedBW = bwboundaries(imerode(maskd,se));

elseif eventdata.VerticalScrollCount > 0
	se = strel('disk',1 ); 
	erodedBW = bwboundaries(imdilate(maskd,se));
end

if ~isempty(erodedBW)
	handles.bw{handles.cIdx} = erodedBW{1};
	plotRegions(hObject, handles)
	guidata(hObject, handles);
end

function showIDs(handles)
for i = 1:length(handles.bw)
	c(1) = mean(handles.bw{i}(:,2));
	c(2) = mean(handles.bw{i}(:,1));
	text(c(1),c(2),num2str(i), 'Color', [1 0 1])
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of checkbox3
if handles.checkbox3.Value ==1
	showIDs(handles);
else
	plotRegions(hObject, handles);
end


% --- Executes when selected cell(s) is changed in roitable.
function roitable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to roitable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(eventdata.Indices)
	handles.cIdx = eventdata.Indices(1);	
	plotRegions(hObject, handles);
	if handles.cIdx ~= length(handles.bw);
		handles.revice_btn.Value = true; hold on;
		maskd = poly2mask(handles.bw{handles.cIdx}(:,2),...
			handles.bw{handles.cIdx}(:,1),...
			size(handles.img, 1), size(handles.img, 2));
		maskc(:,:,1) = maskd;
		maskc(:,:,2) = maskd*0;
		maskc(:,:,3) = maskd;		
		a = imagesc(maskc); alpha(a, 0.4);
	end
end
handles.roitable.Enable='inactive';
guidata(hObject, handles);
handles.roitable.Enable='on';
guidata(hObject, handles);


% --- Executes on button press in rawi_btn.
function rawi_btn_Callback(hObject, eventdata, handles)
% hObject    handle to rawi_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.show = handles.RAW;
plotRegions(hObject, handles)
guidata(hObject, handles);


% --- Executes on button press in sharp_btn.
function sharp_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sharp_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.show = imsharpen(handles.show);
plotRegions(hObject, handles)
guidata(hObject, handles);


% --- Executes on button press in imadj_btn.
function imadj_btn_Callback(hObject, eventdata, handles)
% hObject    handle to imadj_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(size(handles.show))==3
	for i = 1:3
		handles.show(:,:,i) = imadjust(handles.show(:,:,i));
	end
else
	handles.show = imadjust(handles.show);
end
plotRegions(hObject, handles)
guidata(hObject, handles);


% --- Executes on button press in mdfF_btn.
function mdfF_btn_Callback(hObject, eventdata, handles)
% hObject    handle to mdfF_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(size(handles.show))==3
	for i = 1:3
		handles.show(:,:,i) = adapthisteq(handles.show(:,:,i));
	end
else
	handles.show = adapthisteq(handles.show);
end
handles.show = handles.show - min(handles.show(:));
handles.show = handles.show/max(handles.show(:));
size(handles.show)
plotRegions(hObject, handles)
guidata(hObject, handles);


% --- Executes on button press in revice_btn.
function revice_btn_Callback(hObject, eventdata, handles)
% hObject    handle to revice_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.revice_btn.Value;
% Hint: get(hObject,'Value') returns toggle state of revice_btn


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on roitable and none of its controls.
function roitable_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to roitable (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata.Key
if eventdata.Key==('z') || eventdata.Key==('d')
	handles.bw(handles.cIdx) = [];
	if handles.cIdx == 0;
		handles.cIdx =1;
	else
		handles.cIdx =length(handles.bw)+1; 
		handles.revice_btn.Value = false;
	end
elseif eventdata.Key==('r')
	handles.revice_btn.Value = ~handles.revice_btn.Value;
elseif strfind('123456789', eventdata.Key)
	handles.Ctype(handles.cIdx) = str2double(eventdata.Key);
end
plotRegions(hObject, handles)
guidata(hObject, handles);
