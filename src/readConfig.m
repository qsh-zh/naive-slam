function config = readConfig(path)
    config.path = path;
    config.file = 'calib.txt';
    config.calibname = [config.path,config.file];
    T = readtable(config.calibname, 'Delimiter', 'space', 'ReadRowNames', true, 'ReadVariableNames', false);
    A = table2array(T);
    config.P0 = vertcat(A(1,1:4), A(1,5:8), A(1,9:12));
    config.P1 = vertcat(A(2,1:4), A(2,5:8), A(2,9:12));
    %todo: parse nargin
    config.inlierThred = 10;
end
