pose = '../data/pose/00.txt';
T = readtable(pose, 'Delimiter', 'space', 'ReadVariableNames', false);
A = table2array(T);
for i = 1:size(A,1)-1
    formOne =  vertcat(A(i,1:4), A(i,5:8), A(i,9:12));
    nowOne =  vertcat(A(i+1,1:4), A(i+1,5:8), A(i+1,9:12));
    transl = nowOne(1:3,4) - formOne(1:3,4);
    rot    = nowOne(1:3,1:3)/formOne(1:3,1:3);
    gt(i).M = [rot,transl; 0 0 0 1];
    gt(i).pos = formOne;
    gt(i).rot = rot;
    gt(i).tr  = transl;
end
