clear;
clc;
close all; 
% υπολογισμός του output του συστήματος
m = 8.5;
b = 0.65;
k = 2;
u = @(t) 10*cos(0.5* pi*t) + 3;
odefun = @(t,y) [y(2); (-b*y(2) - k*y(1) + u(t))/m];
t = 0:0.1:10;
[t,y] = ode45(odefun,t,[0,0]);
Y = y(:,1);
figure()
plot(t,Y)
ylabel('y')
xlabel('t')
title('Αποτέλεσμα συστήματος για t=[0,10]s')
grid on;
hold on;

% Υπολογισμός των παραμέτρων του συστήματος χρησιμοποιώντας την μέθοδο ελαχίστων τετραγώνων.
denominator = [1,4,2]; % Ë(s) = s^2 + 4s + 2
sys = tf([-1,0],denominator); 
F(:,1) = lsim(sys,Y,t);
sys = tf(-1,denominator);
F(:,2) = lsim(sys,Y,t);
sys = tf(1,denominator);
F(:,3) = lsim(sys,u(t),t);
theta = Y'*F/(F'*F);

% υπολογισμός m,b,k παραμέτρων 
m1 = 1/theta(3);
b1 = (theta(1) + 4)*m1;
k1 = (theta(2) + 2)*m1;

%υπολογισμός του νέου output του συστήματος χρησιμοποιώντας τις νέους παραμέτρους 

odefun = @(t,y) [y(2); (-b1*y(2) - k1*y(1) + u(t))/m1];
[t,y] = ode45(odefun,t,[0,0]);
Y_bar = y(:,1);
plot(t,Y_bar);
hold off;
legend('Y','Y_{hat}');

%plot y - y_hat
e = Y - Y_bar;
figure()
plot(t,e)
ylabel('e')
xlabel('t')
title('Σφάλμα e = y - y_{hat}')