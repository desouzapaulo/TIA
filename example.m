close all
clear all
clc
% ======================================INPUT=================================================
%% Load folder
folder = 'C:\Users\Paulo Bolsista\Desktop\TIA';
logger = "SET";
%% Parameters
filename = folder + "\parameters\GT3.xlsx";
parameters = readmatrix(filename);
mup = 0.45; % coefficient of friction of the brake pad
IW = [1.505 1.505]; % moment of inercia of the wheel (front, rear) [m^4***]

BBB = 0.5; % Brake balance bar proportion (percentage of braking balance to the rear)
psi = 0.55; % portion of the wheight for the rear
chi = 0.2; % vertical portion of the wheight
Fpedal = 400;

% ======================================OUTPUT================================================
%% Initial
foldername = folder + "\data\Phone\formula-2";
brake = BrakeClass(foldername, logger, psi, chi, BBB, parameters);
brake.Fpedal = Fpedal;
brake.mu = [0.99 0.99];
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
%% Plots
brake.pltbrakeline

figure
grid on 
hold all
grid('minor')
ylabel('Pressão total nas linhas de freio [Bar]')
xlabel('Força aplicada no pedal [Kg]')
title('Porsche GT3 R')

cil = 5/8; 
brake.Amc = [(((cil)*2.54)/2)^2*pi (((cil)*2.54)/2)^2*pi];
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
plot((brake.Fpedal_var./brake.g),(brake.Fx_real(:, 1)./brake.W+brake.Fx_real(:, 2)./brake.W), 'DisplayName', '5/8')
% plot((brake.Fpedal_var./brake.g),(brake.Pl(:, 1).*0.1+brake.Pl(:, 2).*0.1), 'DisplayName', '5/8')


cil = 3/4; 
brake.Amc = [(((cil)*2.54)/2)^2*pi (((cil)*2.54)/2)^2*pi];
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
plot((brake.Fpedal_var./brake.g),(brake.Fx_real(:, 1)./brake.W+brake.Fx_real(:, 2)./brake.W), 'DisplayName', '3/4')
% plot((brake.Fpedal_var./brake.g),(brake.Pl(:, 1).*0.1+brake.Pl(:, 2).*0.1), 'DisplayName', '3/4')


cil = 7/8; 
brake.Amc = [(((cil)*2.54)/2)^2*pi (((cil)*2.54)/2)^2*pi];
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
plot((brake.Fpedal_var./brake.g),(brake.Fx_real(:, 1)./brake.W+brake.Fx_real(:, 2)./brake.W), 'DisplayName', '7/8')
% plot((brake.Fpedal_var./brake.g),(brake.Pl(:, 1).*0.1+brake.Pl(:, 2).*0.1), 'DisplayName', '7/8')


 
brake.Amc = [((2.7)/2)^2*pi ((2.7)/2)^2*pi];
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
plot((brake.Fpedal_var./brake.g),(brake.Fx_real(:, 1)./brake.W+brake.Fx_real(:, 2)./brake.W), 'DisplayName', '27 mm (gt3)')
% plot((brake.Fpedal_var./brake.g),(brake.Pl(:, 1).*0.1+brake.Pl(:, 2).*0.1), 'DisplayName', '27 mm (gt3)')

legend