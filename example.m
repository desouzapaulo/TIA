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

BBB = 0.5; % Brake balance bar proportion (percentage of braking balance to the rear)
psi = 0.5;
chi = 0.2;

% ======================================OUTPUT================================================
%% Initial
foldername = folder + "\data\Phone\formula-2";
brake = BrakeClass(foldername, logger, psi, chi, BBB, parameters);
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
%% Plots
brake.pltbrakeline
