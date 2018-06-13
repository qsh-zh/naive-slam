function motion=naiveSlam(path,numFrame)
    config = readConfig(path);
    for pCount = 0:numFrame-1
        imageBag = readImage(config,pCount);
        deepBag = extractDeep(config,imageBag);
        tranMatrix = calTranMatrix(config,deepBag);
        motion(pCount+1).tranMatrix = tranMatrix;
    end
end
