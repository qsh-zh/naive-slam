%todo:???
%% this function is used in the clique selection part of the algorithm
% INPUT:
% clique: the current clique (a vector containing node indices)
% M: the graph, represented as an adjacency matrix

% OUTPUT:
% newSet -> a set of potential nodes that can added to the clique, such
% that is still remains a clique if one of these nodes is added. A vector
% containing the indices of the potential nodes

function newSet = findPotentialNodes(clique, M)

newSet = M(:,clique(1));
if (size(clique)>1)
    for i=2:length(clique)
        newSet = newSet & M(:,clique(i));
    end
end

for i=1:length(clique)
    newSet(clique(i)) = 0;
end


