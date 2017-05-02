function f = readbintext(filename)

% filename='testRead.bin';
A=importdata(filename);
A=A.data;


%   1       2   3   4   5   6       7       8       9   10  11  12
% Cas44178	X	Y	Xc	Yc	Height	Area	Width	Phi	Ax	BG	I	
%   13  14      15      16      17  18
% Frame	Length	Link	Valid	Z	Zc

x = (A(:,2));
y = (A(:,3));
xc = (A(:,4));
yc = (A(:,5));
z = (A(:,17));
zc = (A(:,18));
h = (A(:,6));
area = (A(:,7));
width = (A(:,8));
phi = (A(:,9));
Ax = (A(:,10));
bg = (A(:,11));
I = (A(:,12));


N=numel(x)
cat = (A(:,1));
valid = (A(:,16));
frame = (A(:,13));
length = (A(:,14));
link=(A(:,15));
clear A;



%N = min([ size(cat,1),size(z,1),size(bg,1),size(area,1) ]);
ind = 1:N;
%N = size(ind,1);
% mol = struct('cat',{cat(ind)},'x',{x(ind)},'y',{y(ind)},'z',{z(ind)},'h',{h(ind)},'area',{area(ind)},'width',{width(ind)},'phi',{phi(ind)},         'Ax',{Ax(ind)},'bg',{bg(ind)},'I',{I(ind)},'frame',{frame(ind)},'length',{length(ind)},'link',{-1*ones(N,1)},'valid',{valid(ind)});
mol.cat = cat(ind);
mol.x = x(ind);
mol.y = y(ind);
mol.z = z(ind);
mol.xc = xc(ind);
mol.yc = yc(ind);
mol.zc = zc(ind);
mol.h = h(ind);
mol.area = area(ind);
mol.width = width(ind);
mol.phi = phi(ind);
mol.Ax = Ax(ind);
mol.bg = bg(ind);
mol.I = I(ind);
mol.frame = frame(ind);
mol.length = length(ind);
mol.link = link(ind);
mol.valid = valid(ind);

mol.N=N;
mol.TotalFrames=max(frame);

f = mol;