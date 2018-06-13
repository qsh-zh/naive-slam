function points3D = gen3dPoints(pts_l,pts_r,Pl,Pr)
% build-in method just a wrap
pts_l = pts_l.Location;
pts_r = pts_r.Location;

points3D = triangulate(pts_l, pts_r, Pl', Pr')';
end

