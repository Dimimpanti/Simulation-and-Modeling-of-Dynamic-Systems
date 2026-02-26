clear;
clc;
close all; 

a = 2;
b = 5;
h0 = 0.5;
f = 40;
theta_m = 0.1;

u = @(t)(3*cos(2*t));
h = @(t)h0*sin(2*pi*f*t);

t= 0:0.01:60;

%% Ektimish parametrwn me xrhsh ektimhth parallhlhs domhs

% Choose g1,g2
 g1_range = [10,15,20,25,30];
 g2_range = [10,15,20,25,30];
 [g1,g2] = choose_g1_g2(1,a,b,theta_m,g1_range,g2_range,u,t);

% Parameter estimtion with f = 30 Hz and h0 = 0.25
[x_pred,a_pred,b_pred] = Parallel_structure(a,b,g1,g2,u,h,f,h0,t);

% Dependance of the parameter estimation from frequency of external noise
 f = [5,15,60,90];
 for i = 1:4
     h = @(t)h0*sin(2*pi*f(i)*t);
    [x_pred,a_pred,b_pred] = Parallel_structure(a,b,g1,g2,u,h,f(i),h0,t);
 end

% Dependance of the parameter estimation from h0 of external noise
h0 = [0.75,2,5];
f = 40;
for i = 1:length(h0)
    h = @(t)h0(i)*sin(2*pi*f*t);
    [x_pred,a_pred,b_pred] = Parallel_structure(a,b,g1,g2,u,h,f,h0(i),t);
end

%% Ektimish parametrwn me xrhsh ektimhth mikths domhs
h0 = 0.5;
f = 40;

u = @(t)(3*cos(2*t));
h = @(t)h0*sin(2*pi*f*t);

% Choose g1,g2
g1_range = [10,15,20,25,30];
g2_range = [10,15,20,25,30];
[g1,g2] = choose_g1_g2(2,a,b,theta_m,g1_range,g2_range,u,t);

% Parameter estimtion with f = 30 Hz and h0 = 0.25
[x_pred,a_pred,b_pred] = Mixed_structure(a,b,theta_m,g1,g2,u,h,f,h0,t);

% Dependance of the parameter estimation from frequency of external noise
f = [5,15,60,90];
for i = 1:length(f)
    h = @(t)h0*sin(2*pi*f(i)*t);
    [x_pred,a_pred,b_pred] = Mixed_structure(a,b,theta_m,g1,g2,u,h,f(i),h0,t);
end

% Dependance of the parameter estimation from h0 of external noise
h0 = [0.5,0.75,1,1.2];
f = 40;
for i = 1:length(h0)
    h = @(t)h0(i)*sin(2*pi*f*t);
    [x_pred,a_pred,b_pred] = Mixed_structure(a,b,theta_m,g1,g2,u,h,f,h0(i),t);
end