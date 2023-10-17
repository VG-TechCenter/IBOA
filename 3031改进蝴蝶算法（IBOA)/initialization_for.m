%—————————————————感谢关注了不起的群智能

% This function randomly initializes the position of agents in the search space.
function [X]=initialization_for(N,dim,up,down)

if size(up,2)==1
    X=rand(N,dim).*(up-down)+down;
end
if size(up,2)>1
    for i = 1:N
        for j=1:dim
             high=up(j);
             low=down(j);
             X(i,j)=rand*(high-low)+low;
        end
    end
end