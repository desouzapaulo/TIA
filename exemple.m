close all
clear
clc
%% folder location
folder = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Logger_formula_2";
%folder = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Colégio_de_Aplicação_da_UFRGS-2023-11-20_21-25-31";
%folder = 'D:\Paulo (bolsista)\Data-Analyzer\data\Logger_formula_2';
sensor = "Accelerometer";
Aq = 100; % Hz
data = AnalyzeClass(folder, sensor, Aq);
%% Acquisition rate [Hz]
plot(data.acqrt)
ylabel('Acquisition rate [Hz]')
%% Basic methods 
data.normdata()
data.fft()
data.filter(5)
%data.interval(25, 35)
%% parameters
CG = [0.9 0.0 0.35];        % CG position (x, y, z)                
L = 1.55;                   % Mheel base
g = 9.81;                   % gravity (m/s^2)
W = (296 + 80)*g;           % total weight (N)
Rp = [0.252 0.252];         % braque pad radious (front, rear)
IM = [1.64 1.64];           % moment of inercia of the wheel (front, rear)
Rext = [0.097 0.106];       % external radious of brake caliper (front, rear)
Hp = [0.021 0.021];         % brake pad higth from wheel center
mup = 0.45;                 % coefficient of friction of the brake pad 
Acp = 0.00098;              % total area of the brake pads cylinders (front, rear)
Acm = 0.00019;              % master cylinder area
Hr = 0.2;                   % brake pedal ratio (cylinder/brake shoe)
%% Brake methods
data.scale(1/g)
brake = BrakeClass(data.data(:, 2), data.t, CG, L, W, Rp, IM, Rext, Hp, mup, Acp, Acm, Hr);
%brake.acc(n)
%brake.mudata(n)
%brake.dynreac(n)
%brake.lockforce(n)
%brake.btorque(n)
%brake.frictionforce(n)
%brake.hydpressure(n)
%brake.cylinderforce(n)
%brake.pedalforce(n)