close all
clear all
clc
% ======================================INPUT=================================================
%% Load files
folder = 'C:\Users\paulo\Desktop\TIA';
logger = "SET";
filename = folder + "\parameters\UFSC.xlsx";
parameters = readmatrix(filename);
BBB = 0.5;
psi = 0.49;
chi = 0.19;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger, psi, chi, BBB, parameters);
brake.mu = [0.8 0.8];

%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction

figure
hold all
grid minor
grid on
plot(brake.Fpedal_var./9.81, brake.Pl(:, 1).*0.1)
