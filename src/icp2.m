function transM = icp2(newfeatures1,newfeatures2,newCloud1,newCloud2,P1)
options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','MaxFunEvals',1500);
lb = [];
ub = [];
PAR0 = [0;0;0;0;0;0];
PAR = [0;0;0;0;0;0];


[PAR,resnorm,residual,~,output1] = lsqnonlin(@(PAR) minimize(PAR, newfeatures1, newfeatures2, newCloud1, newCloud2, P1),PAR0, lb, ub, options);

TF11 = residual(1:0.5*size(residual,1), 1)>=1.0;
TF12 = residual(1:0.5*size(residual,1), 2)>=1.0;
TF1 = bitor(TF11, TF12);
TF21 = residual(0.5*size(residual,1)+1:size(residual,1), 1)>=1.0;
TF22 = residual(0.5*size(residual,1)+1:size(residual,1), 2)>=1.0;
TF2 = bitor(TF21, TF22);

TF = bitor(TF1,TF2);

newfeatures1(TF,:) = [];
newfeatures2(TF,:) = [];
newCloud1(TF,:) = [];
newCloud2(TF,:) = [];

[PAR,resnorm,residual,~,output1] = lsqnonlin(@(PAR) minimize(PAR, newfeatures1, newfeatures2, newCloud1, newCloud2, P1),PAR, lb, ub, options);


r = PAR(1:3);
t = PAR(4:6);
R = angle2dcm( r(1), r(2), r(3), 'ZXZ' );
T = t;
transM = [R,T;0 0 0 1];
end
