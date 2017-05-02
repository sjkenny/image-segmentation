
%warp molecule list forward
if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.bin',LastFolder);
else
    GetFileName='*.bin';
end

[FileNameR,PathNameR] = uigetfile(GetFileName,'Select bin file');

RightFile =sprintf('%s%s',PathNameR,FileNameR);
LastFolder=PathNameR;
r= readbinfileNXcYcZc(RightFile);
rx=double(r.xc);
ry=double(r.yc);

ShiftX=0; %-2 for aligning non-split data to split data
rx=rx+ShiftX;


GetFileName=sprintf('%s/*.mat',LastFolder);

[FileName,PathName] = uigetfile(GetFileName,'Select warp file');
tformfile =sprintf('%s%s',PathName,FileName);
tform=importdata(tformfile);

[tx,ty] = tformfwd(tform,rx,ry);
r.x=tx;
r.y=ty;
% figure(1)
% plot(rx,ry,'k.',tx,ty,'m.')
filehead = RightFile(1:end-4);
outfile = sprintf('%s_Warp_fwd.bin',filehead)
WriteMolBinN(r,outfile);

% cat=r.cat;
% global nI xsort;
% [xsort,xI]=sort(r.x);
% nI=r.N(xI);

% Cat1Ind=find(cat==1);
% Cat2Ind=find(cat==2);
% Cat2Num=numel(Cat2Ind);
% Cat1Num=numel(Cat1Ind);
% aa=100*Cat2Num/(Cat1Num+Cat2Num);
% bb=Cat1Num+Cat2Num;
% Cat1z=r.z(Cat1Ind);
% Cat2z=r.z(Cat2Ind);
% [c1counts,c1centers]=hist(Cat1z,50);
% c2counts=hist(Cat2z,50);
% c1counts=c1counts';
% c2counts=c2counts';
% ratio=100.*(c2counts./(c1counts+c2counts));
% num=Cat2Num/(Cat1Num+Cat2Num)
% c1centers=c1centers';
% 
% Cat1Ind=find(cat==1);
% Cat0Ind=find(cat==0);
% Cat0Num=numel(Cat0Ind);
% Cat1Num=numel(Cat1Ind);
% aa=100*Cat0Num/(Cat1Num+Cat0Num);
% bb=Cat1Num+Cat0Num;
% Cat1z=r.z(Cat1Ind);
% Cat0z=r.z(Cat0Ind);
% [c1counts,c1centers]=hist(Cat1z,50);
% c0counts=hist(Cat0z,50);
% c1counts=c1counts';
% c0counts=c0counts';
% ratio=100.*(c1counts./(c1counts+c0counts));
% num=Cat0Num/(Cat1Num+Cat0Num)
% c1centers=c1centers';

% plot(c1centers,ratio,'.','MarkerSize',5)

