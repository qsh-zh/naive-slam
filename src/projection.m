function point2D = projection(points3D)
%myFun - Description
%
% Syntax: points2D = projection(points3D)
% point2D form (u,v,1) in picture
% point3D form (x,y,z,1) in real world
% Long description

% 2018.5.1 elon edit the form to the high-dimension situation!
%size(points2D) n*3
%size(points3D) n*4
    if size(points3D,2) ~=4
        disp('input error, size(points3D,2) should be 4!')
    end
    calibname = '../data/calib.txt';
    T = readtable(calibname, 'Delimiter', 'space', 'ReadRowNames', true, 'ReadVariableNames', false);
    A = table2array(T);
    P1 = vertcat(A(1,1:4), A(1,5:8), A(1,9:12));
    points3D = points3D';
    points2D = P1 * points3D;
    point2D = points2D';
    point2D(:,1) = point2D(:,1) ./ point2D(:,3);
    point2D(:,2) = point2D(:,2) ./ point2D(:,3);
    point2D(:,3) = point2D(:,3) ./ point2D(:,3);
end
