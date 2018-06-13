%todo: ???
%% this function is used in the clique selection part of the algorithm
% INPUT:
% clique: the current clique (a vector containing node indices)
% potentialNodes: list of nodes that can be added to the clique, so that it
% still remains a clique when one such node is added, a vector of node
% indices
% M: the graph, represented as an adjacency matrix

%OUTPUT:
% cl -> the new clique, after adding one of the nodes in the potentialNodes

function cl = updateClique(potentialNodes, clique, M)

maxNumMatches = 0;
curr_max = 0;
for i = 1:length(potentialNodes)
    if(potentialNodes(i)==1)
        numMatches = 0;
        for j = 1:length(potentialNodes)
            if (potentialNodes(j) & M(i,j))
                numMatches = numMatches + 1;
            end
        end
        if (numMatches>=maxNumMatches)
            curr_max = i;
            maxNumMatches = numMatches;
        end
    end
end

if (maxNumMatches~=0)
    clique(length(clique)+1) = curr_max;
end

cl = clique;
