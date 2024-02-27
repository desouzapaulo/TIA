close all
clear all
clc
%% Data Log
folder = "C:\Users\paulo\Desktop\TIA\data\Phone\formula-2";
logger = "Phone";
%% Parameters
phi = 0.49;
X = 0.13;
m = 400;                    % total weight (Kg)
RpF = 0.178;
RpR = 0.178;                % braque pad radious (front, rear)
IWF = 1.505;
IWR = 1.505;                 % moment of inercia of the wheel (front, rear)
RextF = 0.106;
RextR = 0.106;              % external radious of brake caliper (front, rear)
HpF = 0.021;
HpR = 0.021;                % brake pad higth from wheel center
mup = 0.45;                 % coefficient of friction of the brake pad 
Acp = 0.00098;              % total area of the brake pads cylinders (front, rear)
Acm = 0.00019;              % master cylinder area
Hr = 0.044/0.176;                   % brake pedal ratio (cylinder/brake shoe)
%% Initial
brake = BrakeClass(folder, logger);
%% CG Correction
% brake.Acc.C = [0; -0.6; 0.6];  % x, y, z
% brake.Acc.correctCG()
%% Section
brake.Acc.R.section(28, 32);
% brake.Acc.G.R.section(28, 32);
%% Filter
brake.Acc.R.fft()
brake.Acc.R.filter(5)
brake.Acc.R.scale(1/9.81)
brake.Acc.G.R.fft()
brake.Acc.G.R.filter(5)
%% Calculus (Must be in this order)
brake.calcFz(phi, X, m)
brake.calcFx(phi, X, m)
brake.calcmu()
brake.calcTp(RpF, RpR, IWF, IWR)
brake.calcFp(RextF, RextR, HpF, HpR)
brake.calcPh(Acp, mup)
brake.calcFcm(Acm)
brake.calcFpedal(Hr)
%% Graphics
% brake.pltAcc()
% brake.pltmu()
% brake.pltPh()
% brake.pltFpedal()