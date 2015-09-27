close all;
clear all;
load example.ROI.mat
radi = 10;
seD = strel('diamond',1);
img = (ROI.RAW)*255;
img = img(:,:,2);
simg = size(img);

img = img - min(img(:));
imagesc(img); axis image
figure; 

subplot(121)
[a, b] = FastPeakFind(img, 128, [4 4]*radi, 2, 2);
Mi = find(img(:)>0.8*max(img(:))); 
Mmat = zeros(size(img));
Mmat(Mi) = 1;
tmp = imerode(Mmat, seD);
Mmat = imerode(tmp, seD);
imagesc(Mmat); axis image;

[satuBw, L] = bwboundaries(Mmat);
Mx = [];
My = [];
clear reg
subplot(122)
imagesc(img); colorbar; hold on;
for i = 1:length(satuBw)
	reg = poly2mask(...
		satuBw{i}(:,1), satuBw{i}(:,2),...
		simg(1), simg(2));	
	
	reg = regionprops(reg);	
	
	if ~isempty(reg)
		ax=reg.Centroid;
		plot(ax(2), ax(1), 'gd')	
		Mx = [Mx ax(2)];
		My = [My ax(1)];	
	end
	Mx = [Mx ax(2)];
	My = [My ax(1)];
end

[Mix, Miy] = ind2sub(simg, Mi);
x = a(1:2:end); y = a(2:2:end);
%plot(Miy, Mix, '.y')

plot(x,y, 'dr')
axis image
colormap gray
%%

x = [Mx x'];
y = [My y'];
lmask = zeros(size(img));
distance = pdist([x'  y']);
distMat  = squareform(distance);
i=1;
[dx, dy]=find(distMat < 3);
distIdx = dx-dy;
rmvIdx = find(distIdx > 0);
rmvIdx = unique(dx(rmvIdx));
x(rmvIdx) = [];
y(rmvIdx) = [];


%%

%imagesc(ROI.RAW); hold on; axis image;
for i = 1:length(x)
	mask = makeRoundMask([x(i) y(i)], radi*1.2, simg);
	actMask = activecontour(img, mask, 8, 'edge', 0.75);
 	actMask = imfill(actMask, 'holes');
 	tmp = imerode(actMask, seD);
 	actMask = imerode(tmp, seD);	
	bwtmp = bwboundaries(actMask);
	bw{i} = bwtmp{1};
	lmask = actMask+lmask;
	visboundaries(actMask,'Color','g');
	pause(0.005)
end

%%
var{1} = img./max(img(:));
var{2} = bw;
var{3} = ones(length(bw));
ezROI(var)