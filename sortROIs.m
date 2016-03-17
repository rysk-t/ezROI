function sorted_ROI = sortROIs(ROI)
% sorted = sortROIs(ROI)
%    ROI: ROI definition by ezROI
%    sorted_ROI: sorted ROI woth their x Axis;
%
% 2016 Ryosuke Takeuchi

for c = 1:length(ROI.bw)
	xs(c) = mean(ROI.bw{c}(:,2));
end

[rows, idx] = sortrows(xs(:));
for c = 1:length(idx)
	sorted_ROI.bw{c} = ROI.bw{idx(c)};
	sorted_ROI.Ctype(c) = ROI.Ctype(idx(c));
end
sorted_ROI.RAW = ROI.RAW;