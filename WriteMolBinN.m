function f = WriteMolBinN(mol,filename)

BinHeader=zeros(1,4,'int32');
BinHeader(1)=892482637;
BinHeader(2)=mol.TotalFrames;
BinHeader(3)=6;
BinHeader(4)=mol.N;

Num=mol.N;
Padding=zeros(1,mol.TotalFrames,'int32');

fid = fopen(filename,'w');
IntDataAr=[mol.cat(1:Num) mol.valid(1:Num) mol.frame(1:Num) mol.length(1:Num) mol.link(1:Num)]';
fwrite(fid,IntDataAr,'int32');
fclose(fid);

fid=fopen(filename,'r');
IntDataAr=fread(fid,[5, inf],'*single')';

mol=[mol.x(1:Num) mol.y(1:Num) mol.x(1:Num) mol.y(1:Num) mol.h(1:Num) mol.area(1:Num) mol.width(1:Num) mol.phi(1:Num) mol.Ax(1:Num) mol.bg(1:Num) mol.I(1:Num) IntDataAr mol.z(1:Num) mol.z(1:Num)]';
fclose(fid);

clear IntDataAr;

fid = fopen(filename,'w');

fwrite(fid, BinHeader, 'int32');
fwrite(fid,mol,'float32');

fwrite(fid,Padding,'int32');

fclose(fid);

clear mol;
f=0;
