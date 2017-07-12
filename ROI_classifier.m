%classifier

%load bin file
%% addpath things might need to be changed
addpath ../common
addpath ../ransac

addpath(genpath('../deep_learning'))
addpath ../
addpath(genpath('common'))
addpath ex1
%%
if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.bin',LastFolder);
else
    GetFileName='*.bin';
end
%cat to search
cat=1;
[FileNameL,PathNameL] = uigetfile(GetFileName,'Select the STORM bin file to crop');
LastFolder=PathNameL;

LeftFile =sprintf('%s%s',PathNameL,FileNameL);
list = readbinfileNXcYcZc(LeftFile);

x=list.xc;
y=list.yc;

frame=list.frame;
framenum = max(frame);

for i=1:framenum
    fprintf('ROI %d of %d \r',i,framenum)
    idx = find(frame==i & list.cat==cat);
    list_num = numel(idx);
    x_now = x(idx);
    y_now = y(idx);
    %PxSize accounted for in ransac_ring
    [t_hist, r_hist, center, score, radius] = ransac_ring(x_now,y_now);
    train_Now = [score/list_num; radius; center';...
                    (r_hist./list_num)'; std(t_hist)/mean(t_hist);...
                    std(r_hist)/mean(r_hist)];
    parameters(:,i) = train_Now;
end
 [label_svm_predict,score_svm_predict] = predict(SVMModel,parameters');   
    
    
    
    
    
