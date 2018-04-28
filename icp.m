function tranMatrix = icp(points2D1,points2D2,points3D1,points3D2,projectFun)
%myFun - Description
%
% Syntax: tranMatrix = icp(points2D1,points2D2,points3D1,points3D2,projectFun)
%
% Long description
% points2D1 stands for in time t a list of  interested point projection in the 2D-pic
% points2D2 stands for in time t+1 a list of interested points projection in the 2D-pic
% points3D1 stands for in time t a list of  interested points in the 3D-real-world
% points3D2 stands for in time t+1 a list of  interested points in the 3D-real-world
% pojection(certain point in points3D) will get ideal point in points2D
% and the points3D ---> points2D through projectFunction
% due to the noise or accurancy, theres is some bais between projection(points3D) and points2D

%Goal
% the goal is to find out the transformation matrix(4*4) from t ----> t+1 tranMatrix * P(t) = P(t+1)
% the tranMatrix should be minimize the total points bais(add points error together)


%there is many methods to define a error term
% error =tranMatrix* points3D1 - points3D2
% error =project(tranMatrix* points3D1) - points2D2
% error =project(inv(tranMatrix)* points3D2) - points2D1
% ...


end
