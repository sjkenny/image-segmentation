% use flood fill on HR image directly
% assign each isolated region to index for separate analysis
% INPUT: conventional image (# of image pixels = # of
% camera pixels, e.g. 256x256)
% - corresponding .bin file
% OUTPUT: .bin file with structures separated by frame number 
% non-colocalized
% - binary images corresponding to regions of colocalization and cellbody
% - binned STORM image
% adjust threshold interactively to match binary image to conventional
% image

%% parameters

bin_length = 0.5;             %any value
% size = 256;                 %img size (256x256)
count_thresh = 1;           %threshold for # of locs in each pixel to 
                            %count for analysis - check background image
filter_img = 0;             %for conv image with high background 
KeepGoing = 1;
area_filter = 1;
area_filter_thresh = 8;     %area in px defined by bin length
%%
addpath ../common
[r,filehead]=OpenMolListTxt;

x=r.xc;
y=r.yc;
xbins = min(x):bin_length:max(x);
ybins = min(y):bin_length:max(y);

[num_out edges mid loc] = histcn([x y],xbins,ybins);
ind_out_size = size(num_out);
nrows = ind_out_size(1);

ind_out_vec = nrows*(loc(:,2)-1)+loc(:,1);

thresh_high = max(num_out(:));
img = mat2gray(num_out);

%filter and make bw img
while KeepGoing==1;
    prompt = 'Set intensity threshold (press 0 to exit): ';

    thresh = input(prompt);
    if thresh==0
        KeepGoing=0;
        break
    end

    thresh_low = thresh/thresh_high;
    if filter_img==1
        img_bw = im2bw(img_subtract,thresh_low);
    else
        img_bw = im2bw(img,thresh_low);
    end
    imshow(img_bw)
end



%do flood fill
im_ff = flood_fill_indices(img_bw);
im_ff_vec = im_ff(:);
num_idx = max(im_ff_vec);
ROI_area = zeros(num_idx,1);
ROI_num = zeros(num_idx,1);

im_ff_vec_filter = im_ff_vec;
%index STORM data using frame number
framenum=0;
for i=1:num_idx
    idx_filter = [];
    idx_out = [];
    px_use = find(im_ff_vec==i);
    %find area
    ROI_area(i) = numel(px_use);
    if area_filter==1
        if ROI_area(i)<=area_filter_thresh
            im_ff_vec_filter(px_use)=0;
        else
            framenum=framenum+1;
        end
    else
        framenum=framenum+1;
    end
    for k=1:numel(px_use)
        idx_assign=[];
        idx_filter_now=[];
        if area_filter==1
            if ROI_area(i)<=area_filter_thresh
                idx_filter_now = find(ind_out_vec==px_use(k));
                
            else
                idx_assign=find(ind_out_vec==px_use(k));
                
            end
        else
            idx_assign = find(ind_out_vec==px_use(k));
        end
        
        idx_out = [idx_out; idx_assign];
        idx_filter = [idx_filter; idx_filter_now];
        
        
    end
    r.frame(idx_out) = framenum;
    r.cat(idx_out) = 2;
    r.cat(idx_filter) = 3;
    ROI_num(i) = numel(idx_out);
end
img_area_filter = reshape(im_ff_vec_filter,size(im_ff));
img_area_filter_bw = im2bw(img_area_filter);
figure
imshow(img_area_filter_bw)

ROI_density = bsxfun(@rdivide,ROI_num,ROI_area);
figure
storm_img = mat2gray(num_out,[0 100]);
roi_area_copy=ROI_area;
roi_area_copy(find(roi_area_copy<=area_filter_thresh))=[];

imshow(storm_img)
outfile = sprintf('%s_floodfill_bin%g_filter%g.bin',filehead,bin_length,area_filter_thresh);
WriteMolBinNXcYcZc(r,outfile);
