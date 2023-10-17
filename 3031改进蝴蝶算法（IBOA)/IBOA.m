function [fmin,best_pos,Convergence_curve]=IBOA(n,N_iter,Lb,Ub,dim,fobj)

p=0.8; % probabibility switch�����ظ���
power_exponent=0.1; % ��ָ��
sensory_modality=0.01; % �о�����

%Initialize the positions of search agents
% Sol=initialization(n,dim,Ub,Lb);
% ���Ľ�1������ѧϰ��Ⱥ��ʼ�����
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
         
          %Calculate fragrance of each butterfly which is correlated with objective function��������Ŀ�꺯����ص�ÿֻ��������ζ
          Fnew=fobj(S(i,:));
          FP=(sensory_modality*(Fnew^power_exponent)); % ÿֻ��������ζ

          %Global or local search
          if rand<p
              % ���Ľ�2��ȫ�������׶��������������
              ori_value = rand(1,dim);
              cauchy_value = tan((ori_value-0.5)*pi);
              Temp_best = best_pos + best_pos.*cauchy_value;
              if ( fobj(Temp_best) < fmin )
                  best_pos = Temp_best;
              end
              dis = rand * rand * best_pos - Sol(i,:);        % ȫ�������׶�
              S(i,:)=Sol(i,:)+dis*FP;
          else
              % ���Ľ�3���������Ȩ�ز��ԡ��
              w=0.4+(0.9-0.4)*rand+sin(pi+(pi*t)/(2*N_iter));
              % Find random butterflies in the neighbourhood
              epsilon=rand;
              JK=randperm(n);
              dis=epsilon*epsilon*Sol(JK(1),:)-Sol(JK(2),:);  % �ֲ������׶�
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
         
         %Update sensory_modality�����¸о�����
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



