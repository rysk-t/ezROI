function varargout = ezROI(varargin)
% function varargout = ezROI(varargin)
%    varargin: image matrix MxN or MxNx3
%    varagout: structure including results of circle detecion & imadjust

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


function ezROI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.ls = 0;
handles.hs = 1;

handles.cpos = [];
handles.cr   = [];
handles.c = [handles.cpos handles.cr];
if isempty(varargin)
	disp('Load Example: coloredChips.png')
	handles.img   = imread('coloredChips.png');
else
	disp('Load Mat')
	handles.img = varargin{1};
end

if length(size(handles.img)) ==2
	disp('gray')
	img = handles.img;
	img = img - min(img(:));
	img = uint8(255*img/max(img(:)));
	img(:,:,1) = handles.img;
	img(:,:,2) = handles.img;
	img(:,:,3) = handles.img;
	handles.img = img;
else
	handles.img = double(handles.img)/double(max(handles.img(:)));	
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


function varargout = ezROI_OutputFcn(hObject, eventdata, handles)
out.imgre    = handles.img;
out.cr       = handles.cr;
out.cxyr     = get(handles.ROItab, 'data');
out.contrast = [handles.ls handles.hs];
varargout{1} = out;
close


function imgrePlot(handles)
imagesc(handles.imgre);	
handles.imgre = double(handles.imgre);
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
	set(handles.rlabel, 'String', ['r:' num2str(int16(handles.cr))]);

	hold off
else
end


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


function imadSld_h_Callback(hObject, eventdata, handles) %#ok<*INUSL>
handles.hs = get(hObject, 'value');
handles.imgre = imadjust((handles.img), [handles.ls, handles.hs]);
imgrePlot(handles);
detectCircle(handles)
guidata(hObject, handles);


function imadSld_h_CreateFcn(hObject, eventdata, handles)
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
handles.cr = get(hObject, 'Value');
detectCircle(handles)
guidata(hObject, handles);


function rSld_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function rrange_Callback(hObject, eventdata, handles)
handles.crRange = str2double(get(handles.rrange, 'String'));
set(handles.rSld, 'Value', double(handles.crRange+4))
set(handles.rSld, 'Min', double(handles.crRange+1))
set(handles.rSld, 'Max', double(max(size(handles.img))*0.25));
handles.crRange
detectCircle(handles)
guidata(hObject, handles);


function rrange_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function varagout = exit_btn_Callback(hObject, eventdata, handles) %#ok<*INUSD>
uiresume();


function autoCircDet_Callback(hObject, eventdata, handles)
clear range
range = str2double(get(handles.rrange, 'String'));
range = int16([-range range]);
radi  = int16(get(handles.rSld, 'Min')):int16(get(handles.rSld, 'Max'));
i=0;
h = waitbar(i, 'Searching ...');

for i = 1:length(radi)/2
	cent = imfindcircles(handles.imgre,  radi(i)+range, ...
		'ObjectPolarity', 'bright');
	cent2 = imfindcircles(handles.imgre, radi(i)+range, ...
		'ObjectPolarity', 'dark');
	
	c(i) = size(cent,1) + size(cent2,1);
	waitbar(i/(length(radi)/2), h)
end

delete(h)
[hoge, maxRidx] = max(c); %#ok<ASGLU>
maxRidx = median(maxRidx);
maxR            = radi(maxRidx);
set(handles.rSld, 'Value', maxR);
handles.cr      = maxR;
handles.crRange = range(2);
detectCircle(handles);
guidata(hObject, handles);


function checkbox1_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
	detectCircle(handles);
else
	imgrePlot(handles)
end
guidata(hObject, handles);
