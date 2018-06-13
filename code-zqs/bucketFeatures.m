function points = bucketFeatures(I, points, bucketSize, numCorners)
[h,b] = size(I);
h_break=floor(h/bucketSize);
b_break=floor(b/bucketSize);

y = floor(linspace(1, h - h/h_break, h_break));
x = floor(linspace(1, b - b/b_break, b_break));

final_points = [];
for i=1:length(y)
    for j=1:length(x)
        bucket=[];
        for k=1:length(points.Location(:,1))
            P=points.Location(k,:);
            if P(1)<x(j)+floor(b/b_break) && P(1)>x(j) && P(2)<y(i)+floor(h/h_break) && P(2)>y(i);
                bucket=vertcat(bucket,P);
            end
        end
        if ~isempty(bucket)
            bucket=cornerPoints(bucket);
            bucket = bucket.selectStrongest(numCorners);
            final_points = vertcat(final_points, bucket.Location);
        end
    end
end
points = cornerPoints(final_points);
