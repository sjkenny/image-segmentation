%draw lines between points
%need to add 1 to match_idx to account for C indexing (starts at 0)

A=importdata('storm_coords_heatmap_coords.match')


%%
clf
plot(centers_heatmap(:,1),centers_heatmap(:,2),'m+','MarkerSize',5)
hold on
plot(coords(:,1),coords(:,2),'b+','MarkerSize',5)

for i=1:length(match_idx)
    heatmap_idx_now = match_idx(i,2);
    storm_idx_now = match_idx(i,1);
    x=[centers_heatmap(heatmap_idx_now,1) coords(storm_idx_now,1)];
    y=[centers_heatmap(heatmap_idx_now,2) coords(storm_idx_now,2)];
    line(x,y)
end
