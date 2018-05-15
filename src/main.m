%% load image
%!:todo  write the auto load function
imgPath = '../data/';
imageL0 = rgb2gray(imread([imgPath,'L000000','.png']));
imageL1 = rgb2gray(imread([imgPath,'L000001','.png']));
imageR0 = rgb2gray(imread([imgPath,'R000000','.png']));
imageR1 = rgb2gray(imread([imgPath,'R000001','.png']));

calibname = '../data/calib.txt';
T = readtable(calibname, 'Delimiter', 'space', 'ReadRowNames', true, 'ReadVariableNames', false);
A = table2array(T);

P0 = vertcat(A(1,1:4), A(1,5:8), A(1,9:12));
P1 = vertcat(A(2,1:4), A(2,5:8), A(2,9:12));
inlierThresh = 10;

%% construct deep info
% !:todo use the build-in function
disparityMap0 = disparity(imageL0,imageR0);
disparityMap1 = disparity(imageL1,imageR1);

%% findFeatures
pointsL0   = vectorFeatures(imageL0);
%% used for check
figure;
pointImageL0 = insertMarker(imageL0, pointsL0.Location, '+', 'Color', 'white');
imshow(pointImageL0)
%% tracking process
%find correspoding points in pic
tracker = vision.PointTracker('MaxBidirectionalError', 1);
initialize(tracker,pointsL0.Location,imageL0);
[pointsL1,valid] = step(tracker,imageL1);
missingP = valid(:) == 0;
posPointsL0 = pointsL0.Location;
posPointsL0(missingP,:) = [];
pointsL1(missingP,:) = [];
posPointsL1 = pointsL1;
%% used for check
figure;
subplot(2,1,1)
pointImageL0 = insertMarker(imageL0, posPointsL0, '+', 'Color', 'red');
imshow(pointImageL0)
subplot(2,1,2)
pointImageL1 = insertMarker(imageL1, posPointsL1, '+', 'Color', 'red');
imshow(pointImageL1)

%% find

pointsL0 = posPointsL0;
pointsL1 = posPointsL1;
pointsL1 = round(pointsL1);
pointsR0 = pointsL0;
pointsR1 = pointsL1;
%% depth detaction
counter =0;
admit = [];
for i = 1:size(pointsL0,1)
    if ((disparityMap0(pointsL0(i,2),pointsL0(i,1))>0)&& ...
        (disparityMap0(pointsL0(i,2),pointsL0(i,1))<100)&& ...
        (disparityMap1(pointsL1(i,2),pointsL1(i,1))>0)&& ...
        (disparityMap1(pointsL1(i,2),pointsL1(i,1))<100))
    pointsR0(i,1) = (pointsL0(i,1)-disparityMap0(pointsL0(i,2),pointsL0(i,1)));
    pointsR1(i,1) = (pointsL1(i,1)-disparityMap1(pointsL1(i,2),pointsL1(i,1)));
    admit(i)= 1;
    counter = counter +1;
    end
end


coPoints = admit(:) == 0;
pointsL0(coPoints,:) = [];
pointsL1(coPoints,:) = [];
pointsR0(coPoints,:) = [];
pointsR1(coPoints,:) = [];
%% used for check
figure;
subplot(2,2,1)
pointImageL0 = insertMarker(imageL0, pointsL0, '+', 'Color', 'red');
imshow(pointImageL0)
subplot(2,2,3)
pointImageL1 = insertMarker(imageL1, pointsL1, '+', 'Color', 'red');
imshow(pointImageL1)
subplot(2,2,2)
pointImageR0 = insertMarker(imageR0, pointsR0, '+', 'Color', 'red');
imshow(pointImageR0)
subplot(2,2,4)
pointImageR1 = insertMarker(imageR1, pointsR1, '+', 'Color', 'red');
imshow(pointImageR1)
%%  have configure the matched features
% svd solve out 3D
points3D0 = ones(size(pointsL0,1),4);
points3D1 = ones(size(pointsR0,1),4);

for i = 1:size(pointsL0,1)
    pos0 = pointsL0(i,:);
    pos1 = pointsR0(i,:);

    A = [
        pos0(1)*P0(3,:)-P0(1,:);
        pos0(2)*P0(3,:)-P0(2,:);
        pos1(1)*P1(3,:)-P1(1,:);
        pos1(2)*P1(3,:)-P1(2,:);
    ];

    [~,~,V]= svd(A);
    X=V(:,end);
    X = X/X(end);
    points3D0(i,:) = X';
end
points3D0 = points3D0(:,1:3);


for i = 1:size(pointsL0,1)
    pos0 = pointsL1(i,:);
    pos1 = pointsR1(i,:);

    A = [
        pos0(1)*P0(3,:)-P0(1,:);
        pos0(2)*P0(3,:)-P0(2,:);
        pos1(1)*P1(3,:)-P1(1,:);
        pos1(2)*P1(3,:)-P1(2,:);
    ];

    [~,~,V]= svd(A);
    X=V(:,end);
    X = X/X(end);
    points3D1(i,:) = X';
end
points3D1 = points3D1(:,1:3);
%%
figure;
subplot(2,1,1)
scatter3(points3D0(:,1),points3D0(:,2),points3D0(:,3));
subplot(2,1,2)
scatter3(points3D1(:,1),points3D1(:,2),points3D1(:,3));

%%
check = ((abs(points3D0(:,1)))>50 |...
    (abs(points3D0(:,2)))>50 |...
    (abs(points3D0(:,3)))>50)...
|...
((abs(points3D1(:,1)))>50 |...
    (abs(points3D1(:,2)))>50 |...
    (abs(points3D1(:,3)))>50);

points3D0(check,:) = [];
points3D1(check,:) = [];
pointsL0(check,:) =[];
pointsL1(check,:) =[];
pointsR0(check,:) =[];
pointsR1(check,:) =[];
%%
figure;
subplot(2,1,1)
scatter3(points3D0(:,1),points3D0(:,2),points3D0(:,3));
subplot(2,1,2)
scatter3(points3D1(:,1),points3D1(:,2),points3D1(:,3));

figure;
subplot(2,2,1)
pointImageL0 = insertMarker(imageL0, pointsL0, '+', 'Color', 'red');
imshow(pointImageL0)
subplot(2,2,3)
pointImageL1 = insertMarker(imageL1, pointsL1, '+', 'Color', 'red');
imshow(pointImageL1)
subplot(2,2,2)
pointImageR0 = insertMarker(imageR0, pointsR0, '+', 'Color', 'red');
imshow(pointImageR0)
subplot(2,2,4)
pointImageR1 = insertMarker(imageR1, pointsR1, '+', 'Color', 'red');
imshow(pointImageR1)


%% build graph to solve
grp = zeros(size(pointsL0,1));
for i = 1:size(pointsL0,1)
    for j = 1:size(pointsL1,1)
        if (...
            abs(...
                norm(points3D1(i,:)-points3D1(j,:))-...
                norm(points3D0(i,:)-points3D0(j,:))...
            )<inlierThresh...
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
tranMatrix = icp(points2D0,points2D1,poitnts3D0,points3D1,@projectFun);

