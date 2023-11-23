clear
clc
%% Folders
folder = 'D:\paulo-bolsista\Data-Analyzer\data\formula-1';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\Logger_formula_2';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-1-2023-11-20_21-25-31';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-2-2023-11-20_21-34-02';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-3-2023-11-20_21-35-55';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-4-2023-11-20_21-42-26';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-5-2023-11-20_21-48-18';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-6-2023-11-20_21-49-28';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-7-2023-11-20_21-38-03';
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-8-2023-11-20_21-40-26'; 
%folder = 'D:\paulo-bolsista\Data-Analyzer\data\baja-9-2023-11-20_21-44-54';
%% Data Log
acc = "Accelerometer";
GPS = "Location";
acc_aq = 100; % Hz
gps_aq = 1;
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
%% Objects
brake = BrakeClass(folder, acc, acc_aq, CG, L, W, Rp, IM, Rext, Hp, mup, Acp, Acm, Hr);
gps = LocationClass(folder, GPS, gps_aq);