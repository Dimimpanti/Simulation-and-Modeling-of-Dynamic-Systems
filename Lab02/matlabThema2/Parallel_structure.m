function [x_pred,a_pred,b_pred] = Parallel_structure(a,b,g1,g2,u,h,f,h0,t)

%% Dhmiourgia susthmatos diaforikwn eksiswsewn
% ektimhsh twn katastasewn tou susthmatos otan den exoume thorivo
odefun1 = @(t,x) [-a*x(1)+ b*u(t);
                     -g1*(x(1)-x(4))*x(4);
                      g2*(x(1)-x(4))*u(t);
                      -x(2)*x(4)+x(3)*u(t)];

% ektimhsh twn katastasewn tou susthmatos otan exoume thorivo
odefun2 = @(t,x) [-a*x(1)+ b*u(t);
                     -g1*(x(1)+h(t)-x(4))*x(4);
                      g2*(x(1)+h(t)-x(4))*u(t);
                     -x(2)*x(4)+x(3)*u(t)];
 

[t,x] = ode45(odefun1,t,[0,0,0,0]);
[t,x_noise] = ode45(odefun2,t,[0,0,0,0]);

%% Ektimish parametrwn me xrhsh ektimhth parallhlhs domhs

[t,x] = ode45(odefun1,t,[0,0,0,0]);
[t,x_noise] = ode45(odefun2,t,[0,0,0,0]);

x_pred = x_noise(:,4);
a_pred = x_noise(:,2);
b_pred = x_noise(:,3);
MAE = (sum(abs(x(:,1)- x(:,4))))/length(x); %mean absolute error
MAE_noise = (sum(abs(x_noise(:,1)- x_noise(:,4))))/length(x); %mean absolute error when x is recieved with noise

%x and x_pred with and without noise
figure()
subplot(2,1,1)
hold on;
plot(t,x(:,1));
plot(t,x(:,4));
hold off
grid on;
xticks(0:5:60)
title('[Parallel structure] $x$ and $\hat{x}$ without noise','interpreter','latex','FontSize',25);
xlabel('Time [s]','FontSize',15);
legend('$x$','$\hat{x}$','interpreter','latex','FontSize',25);

subplot(2,1,2)
hold on;
plot(t,x_noise(:,1));
plot(t,x_noise(:,4));
hold off
grid on;
xticks(0:5:60)
title({'[Parallel structure] $x$ and $\hat{x}$ with noise';['f =',num2str(f),', h0 =',num2str(h0)]},'interpreter','latex','FontSize',25);
xlabel('Time [s]','FontSize',15);
legend('$x$','$\hat{x}$','interpreter','latex','FontSize',25);
%saveas(gcf, "f=" + f + "_h0=" + h0 + "_1.pdf");
                
% e = x - x_pred with and without noise
figure()
subplot(2,1,1)
plot(t,x(:,1)- x(:,4));
title('[Parallel structure] e = $x$ - $\hat{x}$ without noise','interpreter','latex','FontSize',25);
xlabel('Time [s]','FontSize',15);
grid on;
xticks(0:5:60)
dim = [.55 .6 .35 .07];
str = strcat('Mean Absolute Error =',num2str(MAE));
annotation('textbox',dim,'String',str,'FontSize',12)

subplot(2,1,2)
plot(t,x_noise(:,1)- x_noise(:,4));
title({'[Parallel structure] e = $x$ - $\hat{x}$ with noise';['f =',num2str(f),', h0 =',num2str(h0)]},'interpreter','latex','FontSize',25);
xlabel('Time [s]','FontSize',15);
grid on;
xticks(0:5:60)
dim = [.55 .125 .35 .07];
str = strcat('Mean Absolute Error =',num2str(MAE_noise));
annotation('textbox',dim,'String',str,'FontSize',12)
%saveas(gcf, "f=" + f + "_h0=" + h0 + "_2.pdf");


% a and b with and without noise
figure()
subplot(2,1,1)
hold on;
plot(t,x_noise(:,2));
plot(t,x(:,2));
yline(1.5,'-k');
hold off
title({'[Parallel structure] a and $\hat{a}$ with and without noise';['f =',num2str(f),', h0 =',num2str(h0)]},'interpreter','latex','FontSize',20);
legend('$\hat{a}$ with noise','$\hat{a}$ without noise','$a_{real}$','interpreter','latex');
xlabel('Time [s]','FontSize',15);
grid on;
xticks(0:5:60)

subplot(2,1,2)
hold on;
plot(t,x_noise(:,3));
plot(t,x(:,3));
yline(2,'-k');
hold off
title({'[Parallel structure] b and $\hat{b}$ with and without noise';['f =',num2str(f),', h0 =',num2str(h0)]},'interpreter','latex','FontSize',20);
legend('$\hat{b}$ with noise','$\hat{b}$ without noise','$b_{real}$','interpreter','latex');
xlabel('Time [s]','FontSize',15);
grid on;
xticks(0:5:60)
%saveas(gcf, "f=" + f + "_h0=" + h0 + "_3.pdf");

fprintf("[Parallel Structure] f = %d and h = %d: Mean Absolute Error = %f\n",f,h0,MAE_noise);
end