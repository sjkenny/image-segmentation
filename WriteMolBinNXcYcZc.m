function f = WriteMolBinNXcYcZc(mol,filename)

BinHeader=zeros(1,4,'int32');
BinHeader(1)=892482637;
BinHeader(2)=mol.TotalFrames;
BinHeader(3)=6;
BinHeader(4)=mol.N;
Padding=zeros(1,mol.TotalFrames,'int32');

fid = fopen(filename,'w');
IntDataAr=[mol.cat mol.valid mol.frame mol.length mol.link]';
fwrite(fid,IntDataAr,'int32');
fclose(fid);

fid=fopen(filename,'r');
IntDataAr=fread(fid,[5, inf],'*single')';

mol=[mol.x mol.y mol.xc mol.yc mol.h mol.area mol.width mol.phi mol.Ax mol.bg mol.I IntDataAr mol.z mol.zc]';
fclose(fid);

clear IntDataAr;

fid = fopen(filename,'w');

fwrite(fid, BinHeader, 'int32');
fwrite(fid,mol,'float32');

fwrite(fid,Padding,'int32');

fclose(fid);

clear mol;
f=0;
