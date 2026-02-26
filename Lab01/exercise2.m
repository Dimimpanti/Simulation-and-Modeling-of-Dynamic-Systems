clear; 
close all;
clc; 

t = 0:1e-4:5;
[Vr,Vc] = v(t); 

% Ορισμός εισόδων
u1 = @(t) 3*sin(pi*t); 
u2 = 2; 

p1 = 100; 
p2 = 150;
l1 = p1 +p2; 
l2 = p1*p2; 

% Υπολογισμός του παρονομαστή του συστήματος
denominator = [1, p1+p2, p1*p2];
% Δημιουργία του μοντέλου συστήματος
sys = tf([-1,0],denominator); 
F(:,1) = lsim(sys,Vc,t); % Απόκριση του συστήματος σε Vc
sys = tf(-1,denominator);
F(:,2) = lsim(sys,Vc,t); % Απόκριση του συστήματος σε Vc
sys = tf([1,0],denominator);
F(:,3) = lsim(sys,u1(t),t); % Απόκριση του συστήματος σε u1(t)
sys = tf(1,denominator);
F(:,4) = lsim(sys,u1(t),t); % Απόκριση του συστήματος σε u1(t)
sys = tf([1,0],denominator);
F(:,5) = lsim(sys,u2*ones(1,length(t)),t); % Απόκριση του συστήματος σε u2
sys = tf(1,denominator);
F(:,6) = lsim(sys,u2*ones(1,length(t)),t); % Απόκριση του συστήματος σε u2

% Εκτίμηση των συντελεστών θέσης
theta = Vc*F/(F'*F);

% Υπολογισμός της εκτιμημένης έξοδου Vc_bar
Vc_bar = F*theta';

% Απεικόνιση των αποκρίσεων του συστήματος
figure();
hold on;
plot(t, Vc,'LineWidth', 2);
plot(t,Vc_bar);
hold off;
title('Έξοδος Συστήματος Vc');
xlabel('Χρόνος');
ylabel('Vc');
legend('Vc','Vc_{bar}');
grid on;

% Υπολογισμός του σφάλματος
e = Vc' - Vc_bar;
figure();
plot(t, e);
ylabel('e')
xlabel('t')
title('e = y - y_{bar}')
grid on;

fprintf('1/RC = %f\n',theta(1) +l1);
fprintf('1/LC = %f',theta(2) + l2);


% Δημιουργία τυχαίων σφαλμάτων
rand_num =  randi([0 length(Vc)],10,1);
Vc(rand_num) = Vc(rand_num) + 20*Vc(rand_num);

% Εκτίμηση των συντελεστών θέσης με τα νέα δεδομένα
theta = Vc*F/(F'*F);

% Υπολογισμός της νέας εκτιμημένης έξοδου Vc_bar
Vc_bar = F*theta';

% Απεικόνιση των αποκρίσεων του συστήματος με τυχαία σφάλματα
figure();
hold on;
plot(t, Vc,'LineWidth', 2);
plot(t,Vc_bar);
hold off;
title('Έξοδος Συστήματος Vc με Τυχαία Σφάλματα');
xlabel('Χρόνος');
ylabel('Vc');
legend('Vc','Vc_{bar}');
grid on;

% Υπολογισμός του νέου σφάλματος
e = Vc' - Vc_bar;
figure();
plot(t, e);
ylabel('e')
xlabel('t')
title('e = y - y_{bar}')
grid on;

fprintf('1/RC = %f\n',theta(1) +l1);
fprintf('1/LC = %f',theta(2) + l2);