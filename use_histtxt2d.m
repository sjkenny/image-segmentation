%get coordinates of cluster centers from STORM brp using HistTxt2D

[r,filehead]=OpenMolList;
%%
CatSelect=2;
valid_thresh=1000;

idx_use = find(r.cat==CatSelect&r.valid>valid_thresh);

x=r.xc(idx_use);
y=r.yc(idx_use);

X = [x y];
%%
[coords,count_copy,count_coords]=HistTxt2D(X,500,5);

imshow(count_copy)
hold on
plot(count_coords(:,2),count_coords(:,1),'m+','MarkerSize',5)

