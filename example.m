close all
clear all
clc
% ======================================INPUT=================================================
%% Load files
folder = 'C:\Users\paulo\Desktop\TIA\data\Phone\formula-2';
logger = "SET";
filename = 'C:\Users\paulo\Desktop\TIA\parameters\RS11.xlsx';
parameters = readmatrix(filename);
BBB = 0.4;
psi = 0.55;
chi = 0.2;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger);
%brake.Acc.Read.filter(3)
%brake.Acc.Read.section(29.4,31.1);
brake.ReadParameters(psi, chi, BBB, parameters);
% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcmu_real
brake.calcmu_optm

figure
hold all
grid minor
plot(brake.a, brake.mu_optm(:, 2), 'Displayname', 'Rear Optm')
plot(brake.a, brake.mu_optm(:, 1), 'Displayname', 'Front Optm')
plot(brake.a, brake.mu_real(:, 2),'Displayname', 'Rear Real')
plot(brake.a, brake.mu_real(:, 1), 'Displayname', 'Front Real')
legend