function [g1_best,g2_best] = choose_g1_g2(choose,a,b,theta_m,g1,g2,u,t)
%fing optimal g1,g2 hor parallel structure
if choose == 1  
    fprintf("[Parallel Structure] Find optimal g1 and g2\n");
    min = 1;
    for i = 1:length(g1)
        for j = 1:length(g2)
            odefun = @(t,x) [-a*x(1)+ b*u(t);
                     -g1(i)*(x(1)-x(4))*x(4);
                      g2(j)*(x(1)-x(4))*u(t);
                      -x(2)*x(4)+x(3)*u(t)];
            [t,x] = ode45(odefun,t,[0,0,0,0]);
            MAE = (sum(abs(x(:,1)- x(:,4))))/length(x); %mean absolute error
            if MAE < min
                min = MAE;
                g1_best = g1(i);
                g2_best = g2(j);
            end
            fprintf("for g1 = %d and g2 = %d, Mean Absulute Error = %f\n",g1(i),g2(j),MAE)
        end 
    end
    fprintf("Optimal pair: [g1,g2] = [%d,%d]\n",g1_best,g2_best);
end
%fing optimal g1,g2 hor mixed structure
if choose == 2
    fprintf("[Mixed Structure] Find optimal g1 and g2\n");
    min = 1;
    for i = 1:length(g1)
        for j = 1:length(g2)
            odefun = @(t,x) [-a*x(1)+ b*u(t);
                     -g1(i)*(x(1)-x(4))*x(4);
                      g2(j)*(x(1)-x(4))*u(t);
                      -x(2)*x(4)+x(3)*u(t)+theta_m*(x(1)-x(4))];
            [t,x] = ode45(odefun,t,[0,0,0,0]);
            MAE = (sum(abs(x(:,1)- x(:,4))))/length(x); %mean absolute error
            if MAE < min
                min = MAE;
                g1_best = g1(i);
                g2_best = g2(j);
            end
            fprintf("for g1 = %d and g2 = %d Mean Absolute Error = %f\n",g1(i),g2(j),MAE)
        end
    end
    fprintf("Optimal pair: [g1,g2] = [%d,%d]\n",g1_best,g2_best);
end
end