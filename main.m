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
%find correspoding points in pic
tracker = vision.PointTracker('MaxBidirectionalError', 1);
initialize(tracker,pointsL0.Location,imageL0);
[pointsL1,valid] = step(tracker,imageL1);
coPoints = valid(:) == 0;
posPointsL0 = pointsL0.Location;
posPointsL0(coPoints,:) = [];
posPointsL1 = posPointsL1(coPoints,:);

%find

pointsL0 = posPointsL0;
pointsL1 = posPointsL1;
pointsL1 = round(pointsL1);
pointsR0 = pointsL0;
pointsR1 = pointsL1;

counter =0;
admit = [];
for i = 1:size(pointsL0,1)
    if ((disparityMap0(pointsL0(i,2),pointsL0(i,1))>0)&&
        (disparityMap0(pointsL0(i,2),pointsL0(i,1))<100)&&
        (disparityMap1(pointsL0(i,2),pointsL0(i,1))>0)&&
        (disparityMap1(pointsL0(i,2),pointsL0(i,1))<100)&&
    )
    pointsR0(i,1) = (pointsL0(i,1)-disparityMap0(pointsL0(i,2),pointsL0(i,1)));
    pointsR1(i,1) = (pointsL1(i,1)-disparityMap1(pointsL2(i,2),pointsL2(i,1)));
    admit(i) = 1;
    counter = counter +1;
    end
end

%
coPoints = admit(:) == 0;
pointsL0(coPoints,:) = [];
pointsL1(coPoints,:) = [];
pointsR0(coPoints,:) = [];
pointsR0(coPoints,:) = [];

% have configure the matched features

points3D0 = ones(size(pointsL0,1),4);
points3D1 = ones(size(pointsL1,1),4);

for i = i:size(pointsL0,1)
    pos0 = pointsL0(i,:);
    pos1 = pointsR0(i,:);

    A = [
        pos0(1)*P0(3,:)-P0(1,:);
        pos0(2)*P0(3,:)-P0(2,:);
        pos1(1)*P1(3,:)-P1(1,:);
        pos1(2)*P1(1,:)-P1(2,:);
    ];

    [~,~V]= svd(A);
    X=V(:,end);
    X = X/X(end);
    points3D0(i,:) = X';
end
points3D0 = points3D0(:,1:3);
% scatter3(points3D0(:,1),points3D0(:,2),points3D0(:,3));

for i = i:size(pointsL0,1)
    pos0 = pointsL1(i,:);
    pos1 = pointsR1(i,:);

    A = [
        pos0(1)*P0(3,:)-P0(1,:);
        pos0(2)*P0(3,:)-P0(2,:);
        pos1(1)*P1(3,:)-P1(1,:);
        pos1(2)*P1(1,:)-P1(2,:);
    ];

    [~,~V]= svd(A);
    X=V(:,end);
    X = X/X(end);
    points3D1(i,:) = X';
end
points3D1 = points3D1(:,1:3);
% scatter3(points3D0(:,1),points3D0(:,2),points3D0(:,3));


check = (
    (abs(points3D0(:,1)))>50 |
    (abs(points3D0(:,2)))>50 |
    (abs(points3D0(:,3)))>50
)|
(
    (abs(points3D1(:,1)))>50 |
    (abs(points3D1(:,2)))>50 |
    (abs(points3D1(:,3)))>50
);

points3D0(check,:) = [];
points3D1(check,:) = [];
pointsL0(check,:) =[];
pointsL1(check,:) =[];
pointsR0(check,:) =[];
pointsR1(check,:) =[];

% build graph to solve
grp = zeros(size(pointsL0,1));
for i = 1:size(pointsL0,1)
    for j = 1:size(pointsL1,1)
        if (
            abs(
                norm(points3D1(i,:)-points3D1(j,:)-
                norm(points3D0(i,:)-points3D0(j,:))
            )
        )
       grp(i,j) = 1;
        end
    end
end


tmp = sum(grp,2);

[M,I] = max(tmp(:));




%% find all pointg correspondence
% !:todo

%% find the maximal set correspondence
% urgly! !:todo

%% icp
% !:todo
