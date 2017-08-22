addpath ../common


[r,filename]=OpenMolListTxt;
CatSelect=2;
CatInd=find(r.cat==CatSelect);
X=[double(r.xc) double(r.yc)];
X=X(CatInd,:);


BinSize=100; %nm

PxSize=160;
BinSizePx=BinSize/PxSize;
rangeX=range(X(:,1));
rangeY=range(X(:,2));

nbinsX=round(rangeX/BinSizePx);
nbinsY=round(rangeY/BinSizePx);
%%


thresh=100;
[count edges mid loc]=histcn(X,nbinsX,nbinsY);
count_copy = count;
img=mat2gray(count);
img_adjust = imadjust(img);
imshow(img_adjust)
FindCenters=0;
crop_size=2;

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