close all
clear variables
clc
%% Data Log
folder = "C:\Users\paulo\Desktop\TIA\data\Phone\formula-2";
logger = "Phone";
%% Parameters
phi = 0.58;
X = 0.1613;
m = 376;                    % total weight (Kg)
RpF = 0.252;
RpR = 0.252;                % braque pad radious (front, rear)
IWF = 1.64;
IWR = 1.64;                 % moment of inercia of the wheel (front, rear)
RextF = 0.097;
RextR = 0.106;              % external radious of brake caliper (front, rear)
HpF = 0.021;
HpR = 0.021;                % brake pad higth from wheel center
mup = 0.45;                 % coefficient of friction of the brake pad 
Acp = 0.00098;              % total area of the brake pads cylinders (front, rear)
Acm = 0.00019;              % master cylinder area
Hr = 0.2;                   % brake pedal ratio (cylinder/brake shoe)
%% Brake Calc
brake = BrakeClass(folder, logger);
brake.Acc.C = [0.1 ; -0.1; 0];
% brake.Acc.correctCG()
brake.calcFz(phi, X, m)
brake.calcFx(phi, X, m)
brake.calcmu()
brake.calcTp(RpF, RpR, IWF, IWR)
brake.calcFp(RextF, RextR, HpF, HpR)
brake.calcPh(Acp, mup)
brake.calcFcm(Acm)
% calcFpedal(Hr)
%% Graphics
brake.pltAcc()
brake.pltmu()
brake.pltPh()
