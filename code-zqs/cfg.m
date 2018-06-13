%% Path to the directories containing images
path1 = 'G:\data_odometry_gray\dataset\sequences\00\image_0\';
path2 = 'G:\data_odometry_gray\dataset\sequences\00\image_1\';

% Number of images in the dataset
Files = dir(strcat(path1,'*.png'));
NumDataSet = length(Files);

% File name style of images stored in the directories
style = Files(1).name;
style = style(style=='0');


% elon move the code 6/11
%% Read the calibration file to find parameters of the cameras
%calibname = fullfile('../data/calib.txt');
%T = readtable(calibname, 'Delimiter', 'space', 'ReadRowNames', true, 'ReadVariableNames', false);
%A = table2array(T);
A=[[7.215377e+02 0.000000e+00 6.095593e+02 0.000000e+00 0.000000e+00 7.215377e+02 1.728540e+02 0.000000e+00 0.000000e+00 0.000000e+00 1.000000e+00 0.000000e+00];
    [7.215377e+02 0.000000e+00 6.095593e+02 -3.875744e+02 0.000000e+00 7.215377e+02 1.728540e+02 0.000000e+00 0.000000e+00 0.000000e+00 1.000000e+00 0.000000e+00]];
P1 = vertcat(A(1,1:4), A(1,5:8), A(1,9:12));
P2 = vertcat(A(2,1:4), A(2,5:8), A(2,9:12));

A = [[9.842439e+02 0.000000e+00 6.900000e+02 0.000000e+00 9.808141e+02 2.331966e+02 0.000000e+00 0.000000e+00 1.000000e+00]; ...
     [9.895267e+02 0.000000e+00 7.020000e+02 0.000000e+00 9.878386e+02 2.455590e+02 0.000000e+00 0.000000e+00 1.000000e+00]];
K1 = vertcat(A(1,1:3), A(1,4:6), A(1,7:9));
K2 = vertcat(A(2,1:3), A(2,4:6), A(2,7:9));
cameraPara1 = cameraParameters('IntrinsicMatrix',K1','RadialDistortion',[-3.728755e-01 2.037299e-01  -7.233722e-02] ,'TangentialDistortion',[2.219027e-03 1.383707e-03]);
cameraPara2 = cameraParameters('IntrinsicMatrix',K2','RadialDistortion',[-3.644661e-01 1.790019e-01  -5.314062e-02] ,'TangentialDistortion',[1.148107e-03 -6.298563e-04]);
A = [9.993513e-01 1.860866e-02 -3.083487e-02 -1.887662e-02 9.997863e-01 -8.421873e-03 3.067156e-02 8.998467e-03 9.994890e-01];
R01 = vertcat(A(1:3), A(4:6), A(7:9));
T01 = [-5.370000e-01 4.822061e-03 -1.252488e-02]-[2.573699e-16 -1.059758e-16 1.614870e-16];
stereoParams = stereoParameters(cameraPara1,cameraPara2,R01,T01);


%% Paramters for Feature Selection
bucketSize = 50; % Size
numCorners = 2;  % Maximum Number 

%% Paramters for RANSAC
s = 15; % smallest numbe
w = 0.9; % Percentage number of inliers desired
p = 0.9999; %Accuracy