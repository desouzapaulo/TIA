close all
clear
clc
%%
%folder1 = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Logger_formula_1";
%folder2 = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Logger_formula_2";
%folder3 = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Rollout_teste_cruze";
folder1 = '/Paulo (bolsista)/Data-Analyzer/data/Logger_formula_2';
folder2 = '/Paulo (bolsista)/Data-Analyzer/data/Logger_formula_2';
folder3 = '/Paulo (bolsista)/Data-Analyzer/data/Rollout_teste_cruze';
sensor = "Accelerometer";
Aq = 100; % Hz
data = AnalyzeClass(folder2, sensor, Aq);
%% parameters
CG = [0.9 0.0 0.25];        % CG position (x, y, z)                
L = 1.55;                   % Mheel base
g = 9.81;                   % gravity
M = (296 + 80);             % total Meight
Rp = [0.252 0.252];         % raio das pastilhas (diant, tras)
IM = [1.64 1.64];           % momento de inércia do conjunto de pneu/roda (diant, tras)
Rext = [0.097 0.106];       % external radious of brake caliper (diant, tras)
Hp = [0.021 0.021];         % altura da pastilha em relação ao centro da roda
mup = 0.45;                 % coeficiente de atrito da pastilha
Acp = 0.00098;              % área total do cilintros das pinças (diant, tras)
Acm = 0.00019;              % master cylinder area
Hr = 0.2;                   % brake pedal ratio (cylinder/brake shoe)
%% Acquisition rate [Hz]
plot(data.acqrt)
ylabel('Acquisition rate [Hz]')
%% Basic methods 
data.normdata()
data.fft()
data.filter(5)
data.interval(28, 35)
%% Brake methods
brake = BrakeClass(data.data(:, 2), data.t, g, CG, L, M, Rp, IM, Rext, Hp, mup, Acp, Acm, Hr);
%brake.acc()
%brake.mudata()
%brake.dynreac()
%brake.lockforce()
%brake.frictionforce()
%brake.hydpressure()
%brake.cylinderforce()
%brake.pedalforce()