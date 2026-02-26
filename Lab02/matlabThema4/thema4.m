
global g1;
global g2;
global theta1;
global theta2;

theta1=0.5;
theta2=2;
g1=1000;
g2=1000;
% Define the time span
step = 0.01;
tspan = 0:step:40;
N = length(tspan);
% Initial condition
xo = [0 0 0 0];
% Solv the ODE using ode45
[t, y] =ode45(@lti, tspan, xo);
x=y(:,1);
xest=y(:,4);
theta1est=y(:,2);
theta2est=y(:,3);
e=y(:,1)-y(:,4);
for i=1:N
    at(i)=theta1;
    bt(i)=theta2;
end
% Plot x(t), x_hat(t), and x(t) - x_hat(t)
figure(1);
plot(t, x, 'b', t, xest, 'r');
title('x(t) and x_{est}(t)');
xlabel('Time');
ylabel('x(t), x_{est}(t)');
legend('x(t)', 'x_{est}(t)');
figure(2);
plot(t, e, 'g');
title('x(t) - x_{est}(t)');
xlabel('Time');
ylabel('x(t) - x_{est}(t)');

figure(3);
plot(t, theta1est, 'm', t, at, 'c');
title('$\hat{a}(t)$ and a', 'Interpreter', 'latex');
xlabel('Time');
ylabel('$\hat{a}(t)$, a', 'Interpreter', 'latex');
figure(4);
plot(t,theta2est, 'm', t, bt, 'c');
title('$\hat{b}(t)$ and b', 'Interpreter', 'latex');
xlabel('Time');
ylabel('$\hat{b}(t)$, b', 'Interpreter', 'latex');

function dx = lti(t, x)
    global g1;
    global g2;
    global theta1;
    global theta2;
    am=1;
    e=x(1)-x(4);
    f=sin(x(1))*(x(1))/2;
    u = 1.5*sin(2*pi*t)*exp(-3*t);
    dx(1) =theta1*f + theta2 * u;        
    dx(2)=g1*e*f;
    dx(3)=g2*e*u;
    dx(4)= x(2)*f + x(3)*u +am*e;
dx=dx';
end