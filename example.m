close all
clear all
clc
% ======================================INPUT=================================================
%% Load files
folder = 'C:\Users\paulo\Desktop\TIA';
logger = "SET";
filename = folder + "\parameters\RS12.xlsx";
parameters = readmatrix(filename);
BBB = 0.6;
psi = 0.55;
chi = 0.2;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger, psi, chi, BBB, parameters);
brake.mu = [0.8 0.8];

%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
%% Plots
brake.pltbrakeline
