function deepBag  = extractDeep(config,image,verbose)
    imageL0 = image.imageL0;
    imageL1 = image.imageL1;
    imageR0 = image.imageR0;
    imageR1 = image.imageR1;
    P0 = config.P0;
    P1 = config.P1;
    if nargin == 2
        verbose = false;
    end

    %STEP1--build the deep map
    disparityMap0 = disparity(imageL0,imageR0);
    disparityMap1 = disparity(imageL1,imageR1);

    %STEP2-- findFeatures
    pointsL0   = vectorFeatures(imageL0);
    if verbose
        figure('Name','imageFeatures');
        pointImageL0 = insertMarker(imageL0, pointsL0.Location, '+', 'Color', 'white');
        imshow(pointImageL0)
    end

    %STEP3-- tracking features points
    %Attention: we only tracking the left-camera feature points!!!
    tracker = vision.PointTracker('MaxBidirectionalError', 1);
    initialize(tracker,pointsL0.Location,imageL0);
    [pointsL1,valid] = step(tracker,imageL1);
    missingP = valid(:) == 0;
    posPointsL0 = double(pointsL0.Location);
    posPointsL0(missingP,:) = [];
    pointsL1(missingP,:) = [];
    posPointsL1 = double(pointsL1);
    if verbose
        figure('Name','imageFeatureTracking');
        subplot(2,1,1)
        pointImageL0 = insertMarker(imageL0, posPointsL0, '+', 'Color', 'red');
        imshow(pointImageL0)
        subplot(2,1,2)
        pointImageL1 = insertMarker(imageL1, posPointsL1, '+', 'Color', 'red');
        imshow(pointImageL1)
    end


    %STEP4-- using disparity info to filtrate useless feartures points(the points distant cannot be too small or too big)
    pointsL0 = posPointsL0;
    pointsL1 = posPointsL1;
    pointsL1 = round(pointsL1);
    pointsR0 = pointsL0;
    pointsR1 = pointsL1;

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

    %delete the points we don't admit
    coPoints = admit(:) == 0;
    pointsL0(coPoints,:) = [];
    pointsL1(coPoints,:) = [];
    pointsR0(coPoints,:) = [];
    pointsR1(coPoints,:) = [];
    if verbose
         figure('Name','First filtrate');
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
    end


    %STEP5-- Build out the deep info using the feature points SVD!
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
    % points3D0 = points3D0(:,1:3);


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
    % points3D1 = points3D1(:,1:3);

    if verbose
         figure('Name','Scatter points!');
         subplot(2,1,1)
         scatter3(points3D0(:,1),points3D0(:,2),points3D0(:,3));
         subplot(2,1,2)
         scatter3(points3D1(:,1),points3D1(:,2),points3D1(:,3));
    end


    %STEP6-- use deep info to filtrate points.
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
    if verbose
        figure('Name','Scatter points after filtrate!');
        subplot(2,1,1)
        scatter3(points3D0(:,1),points3D0(:,2),points3D0(:,3));
        subplot(2,1,2)
        scatter3(points3D1(:,1),points3D1(:,2),points3D1(:,3));
    end
    if verbose
        figure('Name','Feature points ater filtrate!')
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
    end
    %STEP7-- struct the deepBag
    listLength = size(pointsL0,1);
    deepBag.pointsL0 = [pointsL0,ones(listLength,1)];
    deepBag.pointsL1 = [pointsL1,ones(listLength,1)];
    deepBag.pointsR0 = [pointsR0,ones(listLength,1)];
    deepBag.pointsR1 = [pointsR1,ones(listLength,1)];
    deepBag.points3D0 = points3D0;
    deepBag.points3D1 = points3D1;
end
