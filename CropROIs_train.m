%load bin file

addpath ../common
addpath ../ransac
addpath ../
addpath(genpath('common'))
addpath ex1

if exist('LastFolder','var')
    GetFileName=sprintf('%s/*.bin',LastFolder);
else
    GetFileName='*.bin';
end
%cat to search
cat=4;
[FileNameL,PathNameL] = uigetfile(GetFileName,'Select the STORM bin file to crop');
LastFolder=PathNameL;

LeftFile =sprintf('%s%s',PathNameL,FileNameL);
list = readbinfileNXcYcZc(LeftFile);

x=list.xc;
y=list.yc;

frame=list.frame;

train.X = ones(3,list.TotalFrames);
%need to load label
train.y = Correctstructure';

for i=1:list.TotalFrames
    fprintf('ROI %d of %d \r',i,max(frame))
    idx = find(frame==i & list.cat==cat);
    list_num = numel(idx);
    x_now = x(idx);
    y_now = y(idx);
    %PxSize accounted for in ransac_ring
    [center, score, radius] = ransac_ring(x_now,y_now);
    train.X(1,i) = score;
    train.X(2,i) = radius;
    train.X(3,i) = list_num;
end
theta = rand(3,1)*0.1;
options = struct('MaxIter', 100);
%minimize theta
tic;
theta=minFunc(@logistic_regression, theta, options, train.X, train.y);
fprintf('Optimization took %f seconds.\n', toc);

accuracy = binary_classifier_accuracy(theta,train.X,train.y);
fprintf('Training accuracy: %2.1f%%\n', 100*accuracy);