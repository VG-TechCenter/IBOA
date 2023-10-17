function [fmin,best_pos,Convergence_curve]=IBOA(n,N_iter,Lb,Ub,dim,fobj)

p=0.8; % probabibility switch，开关概率
power_exponent=0.1; % 幂指数
sensory_modality=0.01; % 感觉因子

%Initialize the positions of search agents
% Sol=initialization(n,dim,Ub,Lb);
% ★★改进1：反向学习种群初始化★★
Sol_forward=initialization_for(n,dim,Ub,Lb);
Sol_backward=initialization_back(Sol_forward,n,dim,Ub,Lb);
Sol_all=[Sol_forward;Sol_backward];
for i = 1:2*n
    Sol_all_fitness(i)=fobj(Sol_all(i,:));
end
[~,sorted_indexes]=sort(Sol_all_fitness);
for i = 1:n
    Sol(i,:)=Sol_all(sorted_indexes(i),:);
end

for i=1:n
    Fitness(i)=fobj(Sol(i,:));
end

% Find the current best_pos
[fmin,I]=min(Fitness);
best_pos=Sol(I,:);
S=Sol; 

% Start the iterations -- Butterfly Optimization Algorithm 
for t=1:N_iter
        
        for i=1:n% Loop over all butterflies/solutions
         
          %Calculate fragrance of each butterfly which is correlated with objective function，计算与目标函数相关的每只蝴蝶的香味
          Fnew=fobj(S(i,:));
          FP=(sensory_modality*(Fnew^power_exponent)); % 每只蝴蝶的香味

          %Global or local search
          if rand<p
              % ★★改进2：全局搜索阶段引入柯西变异★★
              ori_value = rand(1,dim);
              cauchy_value = tan((ori_value-0.5)*pi);
              Temp_best = best_pos + best_pos.*cauchy_value;
              if ( fobj(Temp_best) < fmin )
                  best_pos = Temp_best;
              end
              dis = rand * rand * best_pos - Sol(i,:);        % 全局搜索阶段
              S(i,:)=Sol(i,:)+dis*FP;
          else
              % ★★改进3：随机惯性权重策略★★
              w=0.4+(0.9-0.4)*rand+sin(pi+(pi*t)/(2*N_iter));
              % Find random butterflies in the neighbourhood
              epsilon=rand;
              JK=randperm(n);
              dis=epsilon*epsilon*Sol(JK(1),:)-Sol(JK(2),:);  % 局部搜索阶段
              S(i,:)=w*Sol(i,:)+dis*FP;                         
          end
          
            % Check if the simple limits/bounds are OK
            S(i,:)=simplebounds(S(i,:),Lb,Ub);
          
            % Evaluate new solutions
            Fnew=fobj(S(i,:));  %Fnew represents new fitness values
            
            % If fitness improves (better solutions found), update then
            if (Fnew<=Fitness(i))
                Sol(i,:)=S(i,:);
                Fitness(i)=Fnew;
            end
           
           % Update the current global best_pos
           if Fnew<=fmin
                best_pos=S(i,:);
                fmin=Fnew;
           end
           
         end
            
         Convergence_curve(t,1)=fmin;
         
         %Update sensory_modality，更新感觉因子
         sensory_modality=sensory_modality_NEW(sensory_modality, N_iter);        
end

% Boundary constraints
function s=simplebounds(s,Lb,Ub)
  % Apply the lower bound
  ns_tmp=s;
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb;
  
  % Apply the upper bounds 
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub;
  % Update this new move 
  s=ns_tmp;

  
function y=sensory_modality_NEW(x,Ngen)
y=x+(0.025/(x*Ngen));



