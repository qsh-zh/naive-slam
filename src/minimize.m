%% the objective function (the reprojection error) which is minimized using
% levenberg-marquardt optimization method
% The parameters
function F = minimize(PAR, F1, F2, W1, W2, P1)
r = PAR(1:3);
t = PAR(4:6);
%F1, F2 -> 2d coordinates of features in I1_l, I2_l
%W1, W2 -> 3d coordinates of the features that have been triangulated
%P1, P2 -> Projection matrices for the two cameras
%r, t -> 3x1 vectors, need to be varied for the minimization
F = zeros(2*size(F1,1), 3);
reproj1 = zeros(size(F1,1), 3);
reproj2 = zeros(size(F1,1), 3);

dcm = angle2dcm( r(1), r(2), r(3), 'ZXZ' );
tran = [ horzcat(dcm, t); [0 0 0 1]];

for k = 1:size(F1,1)
    f1 = F1(k, :)';
    f1(3) = 1;
    w2 = W2(k, :)';
    w2(4) = 1;
    
    f2 = F2(k, :)';
    f2(3) = 1;
    w1 = W1(k, :)';
    w1(4) = 1;
    
    f1_repr = P1*(tran)*w2;
    f1_repr = f1_repr/f1_repr(3);
    f2_repr = P1*pinv(tran)*w1;
    f2_repr = f2_repr/f2_repr(3);
    
    reproj1(k, :) = (f1 - f1_repr);
    reproj2(k, :) = (f2 - f2_repr);    
end

F = [reproj1; reproj2];