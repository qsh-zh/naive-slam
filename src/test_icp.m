%% this is the test file of of icp
load ../data/icpTestData.mat
points2D1 = [points2D1,ones(size(points2D1,1),1)];
points2D2 = [points2D2,ones(size(points2D1,1),1)];
points3D1 = [points3D1,ones(size(points2D1,1),1)];
points3D2 = [points3D2,ones(size(points2D1,1),1)];

result = icp(points2D1,points2D2,points3D1,points3D2,@projection);
result;
disp('Answer')
answer;
