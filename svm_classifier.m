%  This classifier works with regions cropped by CropROIHR_polar
%  Each region is binned into 2D pixels and convolved with a set 
%  of kernels 
%  Region for convolution is defined by edgek - center of ROI is assumed to
%  be [10,10] as defined by offset parameter in CropROIHR_polar
% 
%
%load bin file
%% addpath things might need to be changed

addpath ../common
addpath ../ransac

addpath(genpath('../deep_learning'))
addpath ../
addpath(genpath('common'))
addpath ex1
%%

load('kernels_080817')
load('SVMModel_080817')

if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.bin',LastFolder);
else
    GetFileName='*.bin';
end
%cat to search
cat=2;
[FileNameL,PathNameL] = uigetfile(GetFileName,'Select the STORM bin file to crop');
LastFolder=PathNameL;

LeftFile =sprintf('%s%s',PathNameL,FileNameL);
list = readbinfileNXcYcZc(LeftFile);

x=list.xc;
y=list.yc;

frame=list.frame;

nbins = 11;
bin_size = (11-9)/nbins;
edgek = 9:bin_size:11;
%%
train.X = [];
for i=1:max(list.frame)
    fprintf('ROI %d of %d \r',i,max(list.frame))
    idx = find(frame==i & list.cat==cat);
    list_num = numel(idx);
    x_now = x(idx);
    y_now = y(idx);
    [count edges mid loc] = histcn([x_now y_now],edgek,edgek);
    n=numel(x_now);
    %normalize by max bin
    count_norm=count./max(max(count));
    %normalize by total counts
%     count_norm = count./sum(sum(count));
    
%     
    f_disk_max = max(max(imfilter(count_norm,f_disk,'symmetric')));
    f_gauss_max = max(max(imfilter(count_norm,f_gauss,'symmetric')));
    f_ring_max = max(max(imfilter(count_norm,f_ring,'symmetric')));
    f_disk_small_max = max(max(imfilter(count_norm,f_disk_small,'symmetric')));
    f_disk_large_max = max(max(imfilter(count_norm,f_disk_large,'symmetric')));
    count_std = std(count_norm(:));
    %PxSize accounted for in ransac_ring
%     [t_hist, r_hist, center, score, radius] = ransac_ring(x_now,y_now);
%     train_Now = [score/list_num; radius; center';...
%                     (r_hist./list_num)'; std(t_hist)/mean(t_hist);...
%                     std(r_hist)/mean(r_hist)];

    train_Now = [f_disk_max; f_gauss_max;...
                 f_ring_max; f_disk_small_max;...
                 f_disk_large_max; count_std;...
                 f_disk_large_max-f_ring_max;...
                 f_disk_large_max-f_disk_small_max;...
                 f_disk_large_max-f_gauss_max];
    train.X(:,i) = train_Now;
    
    clf
    plot(x_now,y_now,'k.')
    axis equal
    hold on
    keyboard
end

%% SVM
X=train.X';
[label_svm,score_svm] = predict(SVMModel,X);

%%
% label_idx_1 = find(labels);
% label_idx_0 = find(~labels);
% clf
% plot(train.X(2,label_idx_1),train.X(4,label_idx_1),'k.')
% hold on
% plot(train.X(2,label_idx_0),train.X(4,label_idx_0),'m.')


