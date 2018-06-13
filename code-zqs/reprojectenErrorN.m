function error = reprojectenErrorN(t, R, K1, K2, points3D)
%%Reprojection error function to be minimized for translation t
%   K1, K2: 3 x 3 Intrinsic parameters matrix for the left and right cameras
%   R: 3x3 Estimated rotation matrix from the previous step
%   points3D: 3xM 3D Point cloud generated from stereo pair in left camera
%   frame
%   pts_l: matched feature points locations in left camera frame
%   pts_r: matched feature points locations in right camera frame

% Writing 3D coordinates in homogenous form for left camera
points3D_l = [points3D; ones(1,length(points3D(1,:)))];

% Transformation from left camera to right camera
s =  [-5.370000e-01; 4.822061e-03; -1.252488e-02];
T= [eye(3), s; [0, 0, 0, 1]];
points3D_r = T*points3D_l;

% Retrieving image coordinates from datatype cornerPoints
pts_l = pts_l.Location';
pts_r = pts_r.Location';

% Homogenous coordinates projection on camera's image plane
proj_l = K1*[R, t]*points3D_l;
proj_r = K2*[R, t]*points3D_r;

% Normalize z row of projection to use x and y coordinates.
proj_nl = hom2cart(proj_l')';
proj_nr = hom2cart(proj_r')';


error = [proj_nl(1,:),proj_nl(2,:),proj_nr(1,:),proj_nr(2,:)];
end
