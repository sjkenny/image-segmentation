% this program makes a 2D histogram of molecule .txt data taking parameters
% PxSize and BinSize; it then identifies peaks by iteratively choosing the
% brightest histogram bin, taking the CoM of coordinates in a region
% centered at this bin, removing this region from the list, and continuing
% until no more peaks are identified
% input:
% X: nx2 xy coordinates
% thresh: peak detection threshold

function [coords,count_copy,count_coords] = HistTxt2D(X,thresh,crop_size)

addpath ../common

% 
% [r,filename]=OpenMolListTxt;
% CatSelect=2;
% CatInd=find(r.cat==CatSelect);
% X=[double(r.xc) double(r.yc)];
% X=X(CatInd,:);


BinSize=100; %nm

PxSize=160;
BinSizePx=BinSize/PxSize;
rangeX=range(X(:,1));
rangeY=range(X(:,2));

nbinsX=round(rangeX/BinSizePx);
nbinsY=round(rangeY/BinSizePx);
%%


% thresh=100;
[count edges mid loc]=histcn(X,nbinsX,nbinsY);
count_copy = count;
img=mat2gray(count);
img_adjust = imadjust(img);
imshow(img_adjust)
FindCenters=0;
% crop_size=2;

locX=cell2mat(mid(1));
locY=cell2mat(mid(2));
coords=[];
count_coords=[];
%
im_out = zeros(size(count));
while ~FindCenters
    
    [a,ai]=max(count);
    [b,bi]=max(a); %col
    ai=ai(bi); %row
    if max(a)<thresh
        FindCenters=1;
        break
    end
    aiHigh=min(numel(locX),ai+crop_size);
    aiLow=max(1,ai-crop_size);
    biHigh=min(numel(locY),bi+crop_size);
    biLow=max(1,bi-crop_size);
    roi=count(aiLow:aiHigh,biLow:biHigh);
    indX=locX(aiLow:aiHigh);
    indY=locY(biLow:biHigh);
    meanX=sum(indX*roi)/sum(sum(roi));
    meanY=sum(indY*roi')/sum(sum(roi));
    CoordsNow=[meanX meanY];
    coords=[coords;CoordsNow];
    im_out(ai,bi)=1;
    count_coords_now = [ai bi];
    count_coords = [count_coords;count_coords_now];
       
    count(aiLow:aiHigh,biLow:biHigh)=0;
end

outfile=sprintf('%s-coords',filename)
save(outfile,'coords')
% %% plotting
% clf
% im_large = imresize(imadjust(uint16(count_copy)),1);
% imshow(im_large)
% hold on
% rectangle_size=5;
% coords_adjust = coords.*1;
% count_coords_adjust = count_coords.*1;
% plot(count_coords_adjust(:,2),count_coords_adjust(:,1),'m+')
% 
% imshow(im_large)
% set(gca,'position',[0 0 1 1],'units','normalized')
% set(gca,'LooseInset',get(gca,'TightInset'))
% %%
% for i=1:length(coords)
%     rectangle('Position',[count_coords_adjust(i,2)-rectangle_size/2,...
%         count_coords_adjust(i,1)-rectangle_size/2 rectangle_size rectangle_size],...
%         'EdgeColor','r')
%     
% end
% 
%  
% %%
% thresh=5;
% h=fspecial('disk',1);
% img_conv = imfilter(count,h);
% imshow(imadjust(uint16(img_conv)))
% idx = find(img_conv<thresh);
% img_filter=img_conv;
% img_filter(idx)=0;
% imshow(imadjust(uint16(img_filter)))
  
    
    

