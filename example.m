close all;clear all;clc
% ======================================INPUT=================================================
%% Load files
filename = 'C:\GIT\TIA\parameters\RS12.xlsx';
parameters = readmatrix(filename);
BBB = 0.55; % for the front
psi = 0.55;
chi = 0.2;
mu = 0.8;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(mu);
brake.ReadParameters(psi, chi, BBB, parameters);
% Solve brake
brake.l_p = 5;
brake.solveOptBrake
brake.solveRealBrake

