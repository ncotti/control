%% Example
%   This file serves as an usage example for all the functions defined in
%   this library.

clc; clear; close all;

m = 0.65; % Kg
b = 1.523; % N.s/m
k1 = 1; % N/m
k2 = 19.8; % N/m
Fc = 1; % Hz. 60 lpm
t0 = 0; % Tiempo Inicial de Análisis (s)
tF = 10; % Tiempo Final de Análisis (s)

entrada = [m*b, m*k2, b*(k1+k2), k1*k2];
salida = [b k2];
sys = tf(salida, entrada);
t = t0:0.01:tF;

A = [0 -1/m -1/m;k1 0 0;k2 0 -k2/b];
B = [1/m 0 0]';
C = [0 1/k1 0];
D = [0];

u = @(t) heaviside(t);

G = tf(1, conv([1,6], [1,2]));
H = 1;

%control_simulink("example_block");
%control_ode(entrada, salida, t, u, [0,0,0]);
%control_ss(A,B,C,D, t, u, [0,0,0]);
%control_tf(salida, entrada, t, u);
%control_tf2(sys, t, u);
%control_feedback(G, H, t, u);

