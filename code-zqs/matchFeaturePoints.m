function [pts1,pts2] = matchFeaturePoints(I1,I2,pts1,pts2)
[features1,pts1] = extractFeatures(I1,pts1);
[features2,pts2] = extractFeatures(I2,pts2);
inPair = matchFeatures(features1,features2,'Unique',true);
pts1 = pts1(inPair(:,1));
pts2 = pts2(inPair(:,2));
end

