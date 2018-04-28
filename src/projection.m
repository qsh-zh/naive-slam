function point2D = projection(point3D)
%myFun - Description
%
% Syntax: points2D = projection(points3D)
% point2D form (u,v,1) in picture
% point3D form (x,y,z,1) in real world
% Long description
    calibname = '../data/calib.txt';
    T = readtable(calibname, 'Delimiter', 'space', 'ReadRowNames', true, 'ReadVariableNames', false);
    A = table2array(T);
    P1 = vertcat(A(1,1:4), A(1,5:8), A(1,9:12));
    point2D = P1 * point3D;
    point2D = point2D / point2D(3);

end
