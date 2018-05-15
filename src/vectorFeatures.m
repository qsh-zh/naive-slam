function features = vectorFeatures(img,hStride,bStride,numCorners)
%myFun - Description
%
% Syntax: features = vectorFeatures(img,hStride,bStride,numCorners)
%
% Long description

    [hSize,bSize] = size(img);
    if nargin == 1
        h = 4;
        b = 12;
        numCorners = 100;
    end

    y = floor(linspace(1,hSize-hSize/h,h));
    x = floor(linspace(1,bSize-bSize/b,b));
    yDelta = floor(hSize/h);
    xDelta = floor(bSize/b);
    points = [];
    for i = 1:length(y)
        for j = 1:length(x)
            roi = [x(j),y(i),xDelta,yDelta];
            corners = detectFASTFeatures(img,'ROI',roi, 'MinQuality', 0.00, 'MinContrast', 0.1);
            corners = corners.selectStrongest(numCorners);
            points = vertcat(points,corners.Location);
        end
    end
    features = cornerPoints(points);
end
