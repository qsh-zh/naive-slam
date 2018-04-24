%% load image
%!:todo  write the auto load function
imgPath = '../data/'
imageL0 = rgb2gray(imread([imgPath,'L000000']));
imageL1 = rgb2gray(imread([imgPath,'L000001']));
imageR0 = rgb2gray(imread([imgPath,'R000000']));
imageR1 = rgb2gray(imread([imgPath,'R000001']));

%% construct deep info
% !:todo use the build-in function
disparityMap0 = disparity(imageL0,imageR0);
disparityMap1 = disparity(imageL1,imageR1);

%% findFeatures
pointsL0   = vectorFeatures(imageL0);

%% tracking process
tracker = vision.PointTracker('MaxBidirectionalError', 1);
initialize(tracker,pointsL0.Location,imageL0);

%% find all pointg correspondence
% !:todo

%% find the maximal set correspondence
% urgly! !:todo

%% icp
% !:todo
