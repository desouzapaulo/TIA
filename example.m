close all
clear all
clc
% ======================================INPUT=================================================
%% Load files
folder = 'C:\Users\paulo\Desktop\TIA\data\Phone\formula-2';
logger = "SET";
filename = 'C:\Users\paulo\Desktop\TIA\parameters\RS12.xlsx';
parameters = readmatrix(filename);
BBB = 0.45; % for the rear
psi = 0.55;
chi = 0.2;
acc = 0.95;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger);
brake.ReadParameters(psi, chi, BBB, parameters);
% Solve brake
brake.solveOptBrake
brake.solveRealBrake
brake.solvemu_real
brake.solvemu_optm
brake.solveFpedal(acc)
brake.solvemu(acc)
brake.solvemu_real
brake.solvemu_optm
brake.solveCntFriction
brake.solveBrakeEff

fprintf('\n%.1f kg @ %.2f g\n', brake.Fpedal, acc)
fprintf('\nFront: %.2f [Bar]\nRear: %.2f [Bar]', brake.Pl_Pedal(1), brake.Pl_Pedal(2))
fprintf('\nBraking Efficiency: %.2f [Front]    %.2f [Rear]\n', brake.E(1), brake.E(2))
