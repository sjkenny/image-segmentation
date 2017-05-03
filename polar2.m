function [rad_out]=polar2(x,y,xC,yC,cat)
PxSize=160;
% measure radius of clathrin

CatSelect = find(cat==1);

x1=x(CatSelect);
y1=y(CatSelect);

R=100;
R=R/PxSize;


xShift = x1-xC;
yShift = y1-yC;

[theta,rad]=cart2pol(xShift,yShift);
theta1=theta;

rad1=sort(rad);
rad_out = rad1(round(numel(rad)*0.9));

% Center_Ind=find(rad<R);
% N_center=numel(Center_Ind);
% theta1(Center_Ind)=[];
% rad1(Center_Ind)=[];
% 
% [n,c]=hist(theta1,6);
% a=[n N_center];
