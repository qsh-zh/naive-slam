function R = estimRotation(pts1, pts2, K1, K2, s, w, p )
% todo!!! config file!! 6.06
% homogenous form
pts1 = [pts1.Location'; ones(1,length(pts1))];
pts2 = [pts2.Location'; ones(1,length(pts2))];

% Number of iterations required to find rotation matrix using RANSAC
N = floor(log(1-p)/log(1-w^s));

numPoints = length(pts1(1,:));

minError=1000;
for i = 1:N
    sample = randperm(numPoints, 5);
    [E_all,R_all,~,~] = calEMatrix(pts1(:,sample), pts2(:,sample), K1, K2 );
    error = zeros(1,size(E_all,1));

    for j = 1:size(E_all,1)
        for k = 1:numPoints
            error(j) = error(j) + pts2(:,k)'*inv(K1)'*E_all{j}*inv(K1)*pts1(:,k);
        end
    end
    [~,index] = min(abs(error));
    if error(index) < minError
        R = R_all{index};
        minError=error(index);
    end
end
end
