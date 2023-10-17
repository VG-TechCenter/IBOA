%—————————————————感谢关注了不起的群智能

% This function randomly initializes the position of agents in the search space.
function [X]=initialization_back(Sol_forward,N,dim,up,down)

if size(up,2)==1
    for i = 1:N
        for j = 1:dim
            X(i,j)=rand*(up+down)-Sol_forward(i,j);
            if ( X(i,j)>up )
                X(i,j)=up;
            end
            if ( X(i,j)<down )
                X(i,j)=down;
            end
        end
    end

end
if size(up,2)>1
    for i = 1:N
        for j=1:dim
            high=up(j);
            low=down(j);
            X(i,j)=rand*(high+low)-Sol_forward(i,j);
            if ( X(i,j)>high )
                X(i,j)=high;
            end
            if ( X(i,j)<low )
                X(i,j)=low;
            end
        end
    end
end