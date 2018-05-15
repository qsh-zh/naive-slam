function points2D2=points3D1_to_2D2(twist,points3D1)
twist_hat=[hat(twist(1:3)),twist(4:6);0,0,0,0];
tranMatrix=expm(twist_hat);
points2D2=projection((tranMatrix*points3D1')');
end