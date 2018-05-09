function y = m(i,f)
    f = num2str(f(i));
    name = strcat('20180512_1444',f,'A.jpg')
    im = imread(name);
    imL = im(:,1:2240,:);
    imR = im(:,2241:end,:);
    imwrite(imL,strcat('./L/',f,'L.jpg'))
    imwrite(imR,strcat('./R/',f,'R.jpg'))
    fprintf('over')
end