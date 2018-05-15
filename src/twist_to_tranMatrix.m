function tranMatrix=twist_to_tranMatrix(twist)
%twist is 6¡Á1 vector containing(omega,v)
%twist_hat is a 4*4 matrix, belongs to se(3)
%tranMatrix is the homogeneous transformation matrix
addpath('D:\Matlab from Ding\SLAM\Toolbox\slamtb-master');
twist_hat=[hat(twist(1:3)),twist(4:6);0,0,0,0];
tranMatrix=expm(twist_hat);
end