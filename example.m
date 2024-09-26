close all
clear all
clc
% ======================================INPUT=================================================
%% Load files
folder = 'C:\Users\paulo\Desktop\TIA\data\Phone\baja-3-2023-11-20_21-35-55';
logger = "Phone";
filename = 'C:\Users\paulo\Desktop\TIA\parameters\RS11.xlsx';
parameters = readmatrix(filename);
BBB = 0.45;
psi = 0.65;
chi = 0.19;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger);
brake.Acc.Read.filter(5)
brake.Acc.Read.section(16.3,17.7);
brake.ReadParameters(psi, chi, BBB, parameters);
%% Solve brake
% brake.calcOptBrake
% brake.calcRealBrake
% brake.calcmu(0.8)
% brake.calcmu_var
% brake.calcCntFriction
% brake.calcBrakeEff
brake.pltAcc

