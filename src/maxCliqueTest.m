%% this is a test script to test maxClique function
x = ones(10);
result = maxClique(x);
disp(['The correct result is one person only know him self']);
result;

%%
x = [ 1 1 0; 1 1 0;0 0 1];
result = maxClique(x);
disp(['The correct result is 1&2']);
result;

%% need to go on
