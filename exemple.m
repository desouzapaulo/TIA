close all
clear
clc
%%
folder1 = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Logger_formula_1";
folder2 = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Logger_formula_2";
folder3 = "C:\Users\paulo\Documents\MATLAB\Data-Analyzer\data\Rollout_teste_cruze";
%folder1 = '/Paulo (bolsista)/Data_Analyzer/data/Logger_formula_1';
%folder2 = '/Paulo (bolsista)/Data_Analyzer/data/Logger_formula_2';
%folder3 = '/Paulo (bolsista)/Data_Analyzer/data/Rollout_teste_cruze';
sensor = "Accelerometer";
Aq = 100; % Hz
data = AnalyzeClass(folder2, sensor, Aq);
%% Parâmetros
CG = [0.9 0.0 0.25];        % posição do CG (x, y, z)                
L = 1.55;                   % entre-eixos
g = 9.81;                   % gravidade
W = 296 + 80;               % peso total
Rp = [0.252 0.252];         % raio das pastilhas (diant, tras)
Iw = [1.64 1.64];           % momento de inércia do conjunto de pneu/roda (diant, tras)
Rext = [0.097 0.106];       % raio externo do disco de freio (diant, tras)
Hp = [0.021 0.021];         % altura da pastilha em relação ao centro da roda
mup = 0.45;                 % coeficiente de atrito da pastilha
Acp = 0.00098;              % área total do cilintros das pinças (diant, tras)
Acm = 0.00019;              % área do cilindro mestre
Hr = 0.2;                   % relação do pedal (cilindo/pé)
%% Acquisition rate [Hz]
plot(data.acqrt)
ylabel('Acquisition rate [Hz]')
%% Basic methods 
data.normdata()
data.fft()
data.filter(5)
data.scale(1/g)
data.interval(29, 35)
%% Brake methods
brake = BrakeClass(data.data(: ,2), data.tnorm, CG, L, W, Rp, Iw, Rext, Hp, mup, Acp, Acm, Hr);
%brake.acc()
%brake.mudata()
%brake.dynreac()
%brake.lockforce()
%brake.btorque()
%brake.frictionforce()
%brake.hydpressure()
%brake.cylinderforce()
%brake.pedalforce()