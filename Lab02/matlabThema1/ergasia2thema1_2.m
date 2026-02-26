clear;
clc;
close all; 

a = 4;
b = 1.5;

u = @(t)(5*sin(2*t));
t= 0:0.01:60;

%% Find optimal gamma 
g = [1,5,10,20,30];
am = 5;

figure;
colors = {'b', 'g', 'r', 'm', 'c'};
for i = 1:length(g)
    odefun = @(t,x) [-a*x(1)+b*u(t);
                    g(i)*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(4);
                    g(i)*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(5);
                    -am*x(4)+x(1);
                    -am*x(5)+u(t);
                    -am*x(6) + x(2)*x(6) + x(3)*u(t)];
    [t,x] = ode45(odefun,t,[0,0,0,0,0,0]);

    x_real = x(:,1);
    x_pred = x(:,6);
    e = x_pred - x_real;

    plot(t,e, 'Color', colors{i});
    hold on;
end

xticks(0:5:60)
grid on;
title('Error: $e = x - \hat{x}$ for different $\gamma$','interpreter','latex','FontSize',15);
xlabel('Time [s]','FontSize',12);
ylabel('Error','FontSize',12);
legend('\gamma = 1', '\gamma = 5', '\gamma = 10', '\gamma = 20', '\gamma = 30');
hold off;

%% Find optimal am
g = 20;
am = [1,2,5];

figure;
for i = 1:length(am)
    odefun = @(t,x) [-a*x(1)+b*u(t);
                    g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(4);
                    g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(5);
                    -am(i)*x(4)+x(1);
                    -am(i)*x(5)+u(t);
                    -am(i)*x(6) + x(2)*x(6) + x(3)*u(t)];
    [t,x] = ode45(odefun,t,[0,0,0,0,0,0]);

    a_pred = am(i) - x(:,2);
    b_pred = x(:,3);

    subplot(3,1,i)
    hold on;
    plot(t,a_pred, 'b');
    plot(t,b_pred, 'r');
    yline(1.5,'--b');
    yline(2,'--r');
    hold off;
    grid on;
    xticks(0:5:60)
    title(['$\hat{a}$ and $\hat{b}$ for $a_{m}=$', num2str(am(i))],'interpreter','latex','FontSize',15);
    xlabel('Time [s]','FontSize',12);
    ylabel('Values','FontSize',12);
    legend('$\hat{a}$','$\hat{b}$','$a_{real}$','$b_{real}$','interpreter','latex');
end

%% Estimate parameters using the gradient method
g = 20;
am = 2;

odefun = @(t,x) [-a*x(1)+b*u(t);
                g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(4);
                g*(x(1)-(x(2)*x(4)+x(3)*x(5)))*x(5);
                -am*x(4)+x(1);
                -am*x(5)+u(t);
                -am*x(6) + x(2)*x(6) + x(3)*u(t)];
[t,x] = ode45(odefun,t,[0,0,0,0,0,0]);

a_pred = am - x(:,2);
b_pred = x(:,3);
x_real = x(:,1);
x_pred = x(:,6);
e = x_real - x_pred;

% plot x and the prediction of x using the gradient method
figure()
hold on;
plot(t,x_real, 'b');
plot(t,x_pred, 'r');
hold off;
grid on;
xticks(0:5:60)
title('Plot of $x$ and $\hat{x}$','interpreter','latex','FontSize',15);
xlabel('Time [s]','FontSize',12);
ylabel('Values','FontSize',12);
legend('$x$','$\hat{x}$','interpreter','latex');

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
title('Estimated $\hat{a}$ and $\hat{b}$','interpreter','latex','FontSize',15);
xlabel('Time [s]','FontSize',12);
ylabel('Values','FontSize',12);
legend('$\hat{a}$','$\hat{b}$','$a_{real}$','$b_{real}$','interpreter','latex');

% plot e = x - x_pred
figure()
plot(t,e)
xticks(0:5:60)
grid on;
title('Error: $e = x - \hat{x}$','interpreter','latex','FontSize',15);
xlabel('Time [s]','FontSize',12);
ylabel('Error','FontSize',12);
