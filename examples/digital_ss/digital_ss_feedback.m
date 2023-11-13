clc; clear; close all;

Ra=1;
Jm=0.9;
Bm=6.2;
Kt=1;
Kb=1;
Av=20;
CH=1;
RH=10;
Kv=0.1;
KP=10;
VR=1; % Tensión de referencia elegida
H_inf=1.5; % Altura del tanque pretendida 

A=[-(Ra*Bm+Kb*Kt)/(Ra*Jm) 0 0;
    1 0 0;
    0 Kv/CH -1/(CH*RH)];
B=[Av*Kt/(Ra*Jm);0;0];
C=[0 0 1; 0 0 1];
D=0;
PLC = [-1+1j*1 -1-1j*1 -10]

[Kd, g0d, PLCd, T] = control_digital_ss_feedback(A,B,C, PLC, 1);

g0d = 1.5*g0d;

control_simulink("digital_ss", 0)