close all
clear all
clc
% ======================================INPUT=================================================
%% Load folder
folder = 'C:\Users\paulo\Desktop\TIA\data\Phone\formula-2';
logger = "SET";
%% Parameters
CG = [0.82 0.465 0];          % CG position [x y z] = [(from front axle) (heigth) (symmetry)]
L = 1.51;                   % wheelbase
m = 265;                    % total weight (Kg)
RpF = 0.178;
RpR = 0.178;                % braque pad radious (front, rear)
IWF = 1.505;
IWR = 1.505;                % moment of inercia of the wheel (front, rear)
RextF = 0.106;
RextR = 0.106;              % external radious of brake caliper (front, rear)
HpF = 0.021;
HpR = 0.021;                % brake pad higth from wheel center
mup = 0.45;                 % coefficient of friction of the brake pad 
Acp = 0.00098;              % total area of the brake pads cylinders (front, rear)
Acm = 0.00019;              % master cylinder area
Hr = 0.044/0.176;           % brake pedal ratio (cylinder/brake shoe)
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger);
% %% Filter
% brake.Acc.Read.fft()
% brake.Acc.Read.filter(5)
% brake.Acc.Read.scale(1/9.81)
%% Solve brake
brake.calcFz(CG, L, m)
brake.calcFx
brake.calcmu
brake.calcBL
brake.calcTp(RpF, RpR, IWF, IWR)
brake.calcFp(RextF, RextR, HpF, HpR)
brake.calcPh(Acp, mup)
brake.calcFcm(Acm)
brake.calcFpedal(Hr)
%% Plots
brake.pltAcc
brake.pltFz
brake.pltFx
brake.pltbrakeline
