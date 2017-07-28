%parameterize ROI for classification
%should match parameterization used in CropROIs_train
function [out] = parameterize_ROI(x,y)
load('kernels_norm')
nbins = 11;
bin_size = (11-9)/nbins;
edgek = 9:bin_size:11;
roi_upper = 11;
roi_lower = 9;
idx = find(x<roi_upper&x>roi_lower&y<roi_upper&y>roi_lower);
x_now = x(idx);
y_now = y(idx);
[count edges mid loc] = histcn([x_now y_now],edgek,edgek);
%normalize by max bin
count_norm=count./max(max(count));
%normalize by total counts
count_norm = count./sum(sum(count));

f_disk_max = max(max(imfilter(count_norm,f_disk,'symmetric')));
f_gauss_max = max(max(imfilter(count_norm,f_gauss,'symmetric')));
f_ring_max = max(max(imfilter(count_norm,f_ring,'symmetric')));
f_disk_small_max = max(max(imfilter(count_norm,f_disk_small,'symmetric')));
f_disk_large_max = max(max(imfilter(count_norm,f_disk_large,'symmetric')));
count_std = std(count_norm(:));


out = [f_disk_max; f_gauss_max; f_ring_max; f_disk_small_max; f_disk_large_max; count_std];