close all
clear all
clc
% ======================================INPUT=================================================
%% Load folder
folder = 'C:\Users\paulo\Desktop\TIA\data\Phone\formula-2';
logger = "SET";
%% Parameters
CG = [0.82 0.465]; % CG position [x y z] = [(from front axle) (heigth)] [m]
R = [289 289]; % wheel radius [mm]
Rp = [17.8 17.8]; % braque pad radious (front, rear) [cm]
Rext = [97 94]; % external radious of brake caliper (front, rear) [mm]  
Hp = [24 24]; % brake pad higth from wheel center [mm]
Awc = [8.04 8.04]; % total area of the brake pads cylinders (front, rear) [cm²]
Amc = [1.98 1.98]; % master cylinder cross section area [cm²]
IW = [1.505 1.505]; % moment of inercia of the wheel (front, rear) [m^4***]
L = 1.51; % wheelbase [m]
m = 265; % total weight (Kg)
l_p = 5.97; % brake pedal ratio (cylinder/brake shoe)
mup = 0.45; % coefficient of friction of the brake pad 
BBB = 0.37; % Brake balance bar proportion (percentage of braking balance to the rear)
psi = CG(1)/L;
X = CG(2)/L;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger, psi, X, m, l_p, Amc, Awc, Rext, Hp, R, BBB);
%% Solve brake
brake.calcOptBrake
brake.calcRealBrake
brake.calcCntFriction
%% Plots
brake.pltbrakeline
fprintf('\nHydraulic pressure:\nRear: %.2f [N/cm²]\nFront: %.2f [N/cm²]\n', brake.Pl(1), brake.Pl(2))
