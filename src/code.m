L0 = imread('../data/L000000.png');
R0 = imread('../data/R000000.png');
L1 = imread('../data/L000001.png');
R1 = imread('../data/R000001.png');

d0 = disparity(rgb2gray(L0),rgb2gray(R0));
d1 = disparity(rgb2gray(L1),rgb2gray(R1));

figure
imshow(d0/(max(max(d0))))
figure
imshow(d1/(max(max(d1))))