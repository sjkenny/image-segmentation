function [m]=StructToMat(r)
%frame = 15
m=[double(r.cat) r.x r.y r.z r.xc r.yc r.zc r.h r.area r.width r.phi r.Ax r.bg r.I double(r.frame) double(r.length) double(r.link) double(r.valid)];

