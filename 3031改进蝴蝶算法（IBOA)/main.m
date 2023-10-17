close all
clear 
clc
warning off all

SearchAgents_no=30; % Number of search agents
Max_iteration=500; % Maximum number of iterations

Function_name='F5';

[lb,ub,dim,fobj]=Get_Functions_detailsPRO(Function_name);

[Best_score_BOA,Best_pos_BOA,cg_curve_BOA]=BOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
[Best_score_IBOA,Best_pos_IBOA,cg_curve_IBOA]=IBOA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
% 绘图
figure
func_plot(Function_name);
title(['基准函数',Function_name,'三维图'])
xlabel('x_1');
ylabel('x_2');
zlabel([Function_name,'( x_1 , x_2 )'])
grid on
box on

figure
semilogy(cg_curve_BOA,'Color','k','Linewidth',1.2)
hold on
semilogy(cg_curve_IBOA,'Color','r','Linewidth',1.2)
title('Convergence curve')
xlabel('Iteration');
ylabel('Best score obtained so far');
axis tight
grid on
box on
legend('BOA','IBOA')

display(['The best optimal value of the objective funciton found by BOA is : ', num2str(Best_score_BOA)]);
display(['The best optimal value of the objective funciton found by IBOA is : ', num2str(Best_score_IBOA)]);


