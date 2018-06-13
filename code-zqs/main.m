clc
clear
close all

%% 
cfg;
pos = [0;0;0];
Rpos = eye(3);

%% Start Algorithm
for t = 1: NumDataSet
    tic;
    [R, tr] = visualPipe(t, path1, path2, style);
    toc

    %% Plot the odometry transformed data
    subplot(3,1,3);
    pos = pos + Rpos*tr;
    Rpos = R*Rpos;
    scatter(pos(1),pos(3),'b','filled');
    hold on;
    title(sprintf('Odometry plot at frame %d', t))
    pause(0.005);
end
