close all
clear
clc
%% Folders
folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-2-2023-11-20_21-34-02';
%% Data Log
acc = "Accelerometer";
gps = "Location";
acc_aq = 100; % Hz
gps_aq = 1;
GPS_data = AnalyzeClass(folder, gps, gps_aq);
%% Parameters
CG = [0.9 0.0 0.25];        % CG position (x, y, z)                
L = 1.55;                   % wheel base
W = (296 + 80)*9.81;        % total weight (N)
Rp = [0.252 0.252];         % braque pad radious (front, rear)
IM = [1.64 1.64];           % moment of inercia of the wheel (front, rear)
Rext = [0.097 0.106];       % external radious of brake caliper (front, rear)
Hp = [0.021 0.021];         % brake pad higth from wheel center
mup = 0.45;                 % coefficient of friction of the brake pad 
Acp = 0.00098;              % total area of the brake pads cylinders (front, rear)
Acm = 0.00019;              % master cylinder area
Hr = 0.2;                   % brake pedal ratio (cylinder/brake shoe)
%% Brake methods
brake = BrakeClass(folder, acc, acc_aq, CG, L, W, Rp, IM, Rext, Hp, mup, Acp, Acm, Hr);