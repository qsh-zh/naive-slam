function tranMatrix = calTranMatrix(config,deepBag)
    % the task of the function is
    % build the graph to filtrate userless points and prepare the key points for the icp step
    % using the final points to do icp work

    %STEP1-- build the graph to do max clique search
    pointsL0 = deepBag.pointsL0;
    pointsL1 = deepBag.pointsL1;
    points3D0 = deepBag.points3D0;
    points3D1 = deepBag.points3D1;
    
%     grp = zeros(size(pointsL0,1));
%     for i = 1:size(pointsL0,1)
%         for j = 1:size(pointsL1,1)
%             if (...
%                 abs(...
%                     norm(points3D1(i,:)-points3D1(j,:))-...
%                     norm(points3D0(i,:)-points3D0(j,:))...
%                 )<config.inlierThred...
%             )
%            grp(i,j) = 1;
%             end
%         end
%     end
%     tmp = sum(grp,2);
%     [M,I] = max(tmp(:));
% 
%     %STEP2-- using max clique method to find out
%     clique = [I];
%     potentialNodes = findPotentialNodes(clique,grp);
%     i = 0;
%     while(sum(potentialNodes))
%         clique = updateClique(potentialNodes,clique,grp);
%         potentialNodes = findPotentialNodes(clique,grp);
%         i = i+1;
%     end
    clique = 1:size(pointsL0,1);
    %STEP3-- build new cloud and feature points
    for i = 1:length(clique)
        cloud0(i,:) = points3D0(clique(i),:);
        cloud1(i,:) = points3D1(clique(i),:);
        points0(i,:)=pointsL0(clique(i),:);
        points1(i,:)=pointsL1(clique(i),:);
    end

    %STEP4-- ICP find out the matrix!
    tranMatrix = icp(points0,points1,cloud0,cloud1,@projectFun);

end
