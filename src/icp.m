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
% so that point_ideal_2D1 &point_ideal_2D2 are generated
% due to the noise or accurancy, theres is some bais between projection(points3D) and points2D

%Goal
% the goal is to find out the transformation matrix(4*4) from t ----> t+1 tranMatrix * P(t) = P(t+1)
% the tranMatrix should be minimize the total points bais(add points error together)


%there is many methods to define a error term
% error =tranMatrix* points3D1 - points3D2
% error =project(tranMatrix* points3D1) - points2D2
% error =project(inv(tranMatrix)* points3D2) - points2D1
% ...
twist0=zeros(6,1);
options = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
twist = lsqcurvefit(@points3D1_to_2D2,twist0,points3D1,points2D2,[],[],options);
tranMatrix=twist_to_tranMatrix(twist);
%% below is for checking the error between my answer and the correct answer 
% r=points2D2-projectFun((tranMatrix*points3D1')');
% r=r(:,1:2)';
% norm_of_r=norm(r);
% answer=[0.999990753777939,-0.00282294807164829,-0.00324396714143419,-0.00173725476934404;0.00281538528263486,0.999993314061974,-0.00233354602714945,-0.00325690515378746;0.00325053293172836,0.00232439143331735,0.999992015588187,0.686516918419461;0,0,0,1];
% r_C=points2D2-projectFun((answer*points3D1')');
% r_C=r_C(:,1:2)';
% norm_of_rc=norm(r_C);
end
