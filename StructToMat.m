function [m]=StructToMat(r)
%frame = 15

m=double([r.cat r.x r.y r.z r.xc r.yc r.zc r.h r.area r.width r.phi r.Ax r.bg r.I r.frame r.length r.link r.valid]);

