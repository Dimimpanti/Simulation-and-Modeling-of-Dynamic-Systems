clear;
clc;
close all; 

a = 4;
b = 1.5;

u = 5;
t= 0:0.01:60;

%% βρίσκω το βέλτιστο γ 
g_values = [1,5,10,20,30];
am = 5;

colors = {'b', 'r', 'g', 'm', 'c'};

for i = 1:length(g_values)
    
    
    odefun = @(t,x) [-a*x(1)+b*u;
                    g_values(i)*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(4);
                    g_values(i)*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(5);
                    -am*x(4)+x(1);
                    -am*x(5)+u;
                    -am*x(6) + x(2)*x(6) + x(3)*u];
    [t,x] = ode45(odefun,t,[0,0,0,0,0,0]);

    x_real = x(:,1);
    x_pred = x(:,6);
    e = x_real - x_pred;

    figure()
    plot(t,e, 'Color', colors{i})
    xticks(0:5:60)
    grid on;
    title(['e = x - $\hat{x}$ for gamma=', num2str(g_values(i))],'interpreter','latex','FontSize',25);
    xlabel('Time [s]','FontSize',15);
    ylabel('e = x - $\hat{x}$','interpreter','latex','FontSize',15);
end

%% βρίσκω το βέλτιστο am
g = 20;
am_values = [1,1.5,2,2.5];

for i = 1:length(am_values)
    odefun = @(t,x) [-a*x(1)+b*u;
                    g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(4);
                    g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(5);
                    -am_values(i)*x(4)+x(1);
                    -am_values(i)*x(5)+u;
                    -am_values(i)*x(6) + x(2)*x(6) + x(3)*u];
    [t,x] = ode45(odefun,t,[0,0,0,0,0,0]);

    a_pred = am_values(i) - x(:,2);
    b_pred = x(:,3);

    figure()
    hold on
    plot(t,a_pred, 'Color', colors{1});
    plot(t,b_pred, 'Color', colors{2});
    yline(1.5,'--', 'Color', colors{1});
    yline(2,'--', 'Color', colors{2});
    hold off;
    grid on;
    xticks(0:5:60)
    title(['$\hat{a}$ and $\hat{b}$ for $a_{m}$=', num2str(am_values(i))],'interpreter','latex','FontSize',25);
    xlabel('Time [s]','FontSize',15);
    legend('$\hat{a}$','$\hat{b}$','$a_{real}$','$b_{real}$','interpreter','latex','FontSize',15);
end

%% %% Εκτίμηση παραμέτρων χρησιμοποιώντας τη μέθοδο μέγιστης καθόδου
g = 20;
am = 2;

odefun = @(t,x) [-a*x(1)+b*u;
                g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(4);
                g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(5);
                -am*x(4)+x(1);
                -am*x(5)+u;
                -am*x(6) + x(2)*x(6) + x(3)*u];
[t,x] = ode45(odefun,t,[0,0,0,0,0,0]);

a_pred = am - x(:,2);
b_pred = x(:,3);
x_real = x(:,1);
x_pred = x(:,6);
e = x_real - x_pred;

% plot x and the prediction of x
figure()
hold on;
plot(t,x_real, 'b');
plot(t,x_pred, 'r');
hold off;
grid on;
xticks(0:5:60)
title(['Plot of $x$ and $\hat{x}$'],'interpreter','latex','FontSize',25);
xlabel('Time [s]','FontSize',15);
legend('$x$','$\hat{x}$','interpreter','latex','FontSize',15);

% plot a and b and their predictions
figure()
hold on
plot(t,a_pred, 'b');
plot(t,b_pred, 'r');
yline(1.5,'--b');
yline(2,'--r');
hold off;
grid on;
xticks(0:5:60)
title('$\hat{a}$ and $\hat{b}$','interpreter','latex','FontSize',25);
xlabel('Time [s]','FontSize',15);
legend('$\hat{a}$','$\hat{b}$','$a_{real}$','$b_{real}$','interpreter','latex','FontSize',15);

%plot e = x - x_pred
figure()
plot(t,e, 'm')
xticks(0:5:60)
grid on;
title(['e = x - $\hat{x}$'],'interpreter','latex','FontSize',25);
xlabel('Time [s]','FontSize',15);
ylabel('e = x - $\hat{x}$','interpreter','latex','FontSize',15);
