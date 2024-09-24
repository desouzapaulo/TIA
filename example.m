close all
clear all
clc
% ======================================INPUT=================================================
%% Load files
folder = 'C:\Users\paulo\Desktop\TIA';
logger = "SET";
filename = folder + "\parameters\RS12.xlsx";
parameters = readmatrix(filename);
BBB = 0.55;
psi = 0.65;
chi = 0.19;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger, psi, chi, BBB, parameters);


%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcmu_fix(0.8)
brake.calcmu_var
brake.calcCntFriction
brake.calcBrakeEff

figure
hold all
grid on
grid minor
plot(brake.Acc.Read.data(:, 2), brake.mu_T(:, 1), 'DisplayName', 'Front')
plot(brake.Acc.Read.data(:, 2), brake.mu_T(:, 2), 'DisplayName', 'Rear')
plot(brake.Acc.Read.data(:, 2), brake.Acc.Read.data(:, 2), 'DisplayName', 'Optimum')
legend