close all
clear
clc
%% Load folder
folder = 'C:\Users\paulo\Desktop\TIA\data\Phone\formula-2';
logger = "SET";
%% Parameters
CG = [0.8 0.38 0];          % CG position
L = 1.55;                   % wheelbase
m = 386;                    % total weight (Kg)
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
%% Initial
brake = BrakeClass(folder, logger);
%% Filter
brake.Acc.Read.fft()
brake.Acc.Read.filter(5)
brake.Acc.Read.scale(1/9.81)
%% Solve brake
brake.calcFz(CG, L, m)
brake.calcFx(CG, L, m)
brake.calcmu()
brake.calcTp(RpF, RpR, IWF, IWR)
brake.calcFp(RextF, RextR, HpF, HpR)
brake.calcPh(Acp, mup)
brake.calcFcm(Acm)
brake.calcFpedal(Hr)
brake.calcBL
%% Plots
brake.pltbrakeline