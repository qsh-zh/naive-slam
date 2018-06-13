function [R, tr] = visualPipe(t, path1, path2, style)
addpath('functions');
cfg;
dig1 = imval2str(style,t-1);
dig2 = imval2str(style,t);

%% Read Images with names dig1 and dig2
image1L = imread(strcat(path1,dig1,'.png'));
image1R = imread(strcat(path2,dig1,'.png'));
image2L = imread(strcat(path1,dig2,'.png'));
image2R = imread(strcat(path2,dig2,'.png'));

%% Feature Tracking at time instant t

pts1_l = detectMinEigenFeatures(image1L,'FilterSize',5,'MinQuality',0);
tracker = vision.PointTracker('MaxBidirectionalError', 1);
initialize(tracker, pts1_l.Location, image1L);
[pts2_l, validity] = step(tracker, image2L);

pts1_l(validity(:)==0,:) = [];
pts2_l(validity(:)==0,:) = [];
pts2_l=cornerPoints(pts2_l);

%% Feature points extraction

pts1_r = detectMinEigenFeatures(image1R,'FilterSize',5,'MinQuality',0);
pts2_r = detectMinEigenFeatures(image2R,'FilterSize',5,'MinQuality',0);

%% Circular matching
% compare left frame at t with left frame at t-1
[pts2_l, pts1_l] = matchFeaturePoints(image2L, image1L, pts2_l, pts1_l);

% compare left frame at t-1 with right frame at t-1
[pts1_l, pts1_r] = matchFeaturePoints(image1L, image1R, pts1_l, pts1_r);

% compare right frame at t-1 with right frame at t
[pts1_r, pts2_r] = matchFeaturePoints(image1R, image2R, pts1_r, pts2_r);

% compare right frame at t with left frame at t
[pts2_r, pts2_l] = matchFeaturePoints(image2R, image2L, pts2_r, pts2_l);

%% Feature Selection using bucketing
subplot(3,1,1);
imshow(image2L);
title(sprintf('Feature selection using bucketing at frame %d', t))
hold on
scatter(pts2_l.Location(:,1),pts2_l.Location(:,2),'+r');
pts2_l = bucketFeatures(image2L, pts2_l, bucketSize, numCorners);
scatter(pts2_l.Location(:,1),pts2_l.Location(:,2),'+g');


% Feature Matching to get corresponding points at time instant t and t-1 in
[pts2_l, pts1_l] = matchFeaturePoints(image2L, image1L, pts2_l, pts1_l);
subplot(3,1,2);
showMatchedFeatures(image2L, image1L, pts2_l, pts1_l);
title(sprintf('Matched Features in left camera at frame %d', t))

% RANSAC algorithm to exclude outliers and estimate rotation matrix
R = estimRotation(pts1_l, pts2_l, K1, K1, s, w, p);

%% Translation(tr) Estimation by minimizing Reprojection Error
[pts2_l, pts2_r] = matchFeaturePoints(image2L, image2R, pts2_l, pts2_r);
[pts1_l, pts2_l] = matchFeaturePoints(image1L, image2L, pts1_l, pts2_l);

% todo!!! test the build-in method
[pts1_l, pts1_r] = matchFeaturePoints(image1L, image1R, pts1_l, pts1_r);
points3D_1 = gen3dPoints(pts1_l, pts1_r, P1, P2);

options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','MaxFunEvals',1500);
[pts2_l, pts2_r] = matchFeaturePoints(image2L, image2R, pts2_l, pts2_r);
tr0 = [1; 1; 1];
errorCostFunction = @(tr)double(reprojectenError([tr(1); tr(2); tr(3)], R, K1, K2, points3D_1, pts2_l, pts2_r));
tr = lsqnonlin(errorCostFunction, tr0, [], [], options);

end
