% this program makes a 2D histogram of molecule .txt data taking parameters
% PxSize and BinSize; it then identifies peaks by iteratively choosing the
% brightest histogram bin, taking the CoM of coordinates in a region
% centered at this bin, removing this region from the list, and continuing
% until no more peaks are identified
addpath ../common

thresh=200;

[r,filename]=OpenMolListTxt;
CatSelect=1;
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



[count edges mid loc]=histcn(X,nbinsX,nbinsY);

img=mat2gray(count);
img_adjust = imadjust(img);
imshow(img_adjust)
FindCenters=0;
roi_R=1;

locX=cell2mat(mid(1));
locY=cell2mat(mid(2));
coords=[];

%

while ~FindCenters
    
    [a,ai]=max(count);
    [b,bi]=max(a); %col
    ai=ai(bi); %row
    if max(a)<thresh
        FindCenters=1;
        break
    end
    aiHigh=min(numel(locX),ai+roi_R);
    aiLow=max(1,ai-roi_R);
    biHigh=min(numel(locY),bi+roi_R);
    biLow=max(1,bi-roi_R);
    roi=count(aiLow:aiHigh,biLow:biHigh);
    indX=locX(aiLow:aiHigh);
    indY=locY(biLow:biHigh);
    meanX=sum(indX*roi)/sum(sum(roi));
    meanY=sum(indY*roi')/sum(sum(roi));
    CoordsNow=[meanX meanY];
    coords=[coords;CoordsNow];
    count(aiLow:aiHigh,biLow:biHigh)=0;
end

outfile=sprintf('%s-coords',filename)
save(outfile,'coords')
    
    