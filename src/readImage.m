function imageBag = readImage(config,num,seq)
    if nargin == 2
        seq = true;
    end
    imgPath = config.path;
    if seq
        imageBag.imageL0 =(imread([imgPath,'image_0/',num2str(num,'%06.6i'),'.png']));
        imageBag.imageL1 =(imread([imgPath,'image_0/',num2str(num+1,'%06.6i'),'.png']));
        imageBag.imageR0 =(imread([imgPath,'image_1/',num2str(num,'%06.6i'),'.png']));
        imageBag.imageR1 =(imread([imgPath,'image_1/',num2str(num+1,'%06.6i'),'.png']));
    else
        imageBag.imageL0 = rgb2gray(imread([imgPath,'L',num2str(num,'%06.6i'),'.png']));
        imageBag.imageL1 = rgb2gray(imread([imgPath,'L',num2str(num+1,'%06.6i'),'.png']));
        imageBag.imageR0 = rgb2gray(imread([imgPath,'R',num2str(num,'%06.6i'),'.png']));
        imageBag.imageR1 = rgb2gray(imread([imgPath,'R',num2str(num+1,'%06.6i'),'.png']));
    end
end
