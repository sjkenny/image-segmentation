function [r]=MatToStruct(m)


r.cat         = m(:,1);
r.x           = m(:,2);
r.y           = m(:,3);
r.z           = m(:,4);
r.xc          = m(:,5);
r.yc          = m(:,6);
r.zc          = m(:,7);
r.h           = m(:,8);
r.area        = m(:,9);
r.width       = m(:,10);
r.phi         = m(:,11);
r.Ax          = m(:,12);
r.bg          = m(:,13);
r.I           = m(:,14);
r.frame       = m(:,15);
r.length      = m(:,16);
r.link        = m(:,17);
r.valid       = m(:,18);
r.N           = numel(r.cat);
r.TotalFrames = max(r.frame);
