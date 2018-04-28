%% this is the test file of of icp
load data/icpTestData.mat
result = icp(points2D1,points2D2,points3D1,points3D2,@projection);
result;
disp('Answer')
answer;
