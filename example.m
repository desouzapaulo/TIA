close all
clear all
clc
% ======================================INPUT=================================================
%% Load folder
folder = 'C:\Users\paulo\Desktop\TIA';
logger = "SET";
%% Parameters
filename = folder + "\parameters\RS11.xlsx";
parameters = readmatrix(filename);
mup = 0.45; % coefficient of friction of the brake pad
IW = [1.505 1.505]; % moment of inercia of the wheel (front, rear) [m^4***]
BBB = 0.37; % Brake balance bar proportion (percentage of braking balance to the rear)
psi = 0.54;
chi = 0.3;

% ======================================OUTPUT================================================
%% Initial
foldername = folder + "\data\Phone\formula-2";
brake = BrakeClass(foldername, logger, psi, chi, BBB, parameters);
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
% fprintf('\nHydraulic pressure: %.3f', brake.Pl)
% fprintf('\nBraking force : %.3f [N]',brake.Fx_real)
% fprintf('\nBraque dist: %.2f',brake.phi)
%% Plots
brake.pltbrakeline
