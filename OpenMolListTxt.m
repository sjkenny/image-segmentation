function [r,filehead]=OpenMolListTxt
global LastFolder
if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.txt',LastFolder);
else
    GetFileName='*.txt';
end

[FileNameR,PathNameR] = uigetfile(GetFileName,'Select bin file');

RightFile =sprintf('%s%s',PathNameR,FileNameR);
LastFolder=PathNameR;
r= readbintext(RightFile);
filehead = RightFile(1:end-4);