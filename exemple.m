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
%% Parâmetros
data = AnalyzeClass(folder2, sensor, Aq);
CG = [0.9 0.0 0.25];                
L = 1.55;   
g = 9.81;
W = 296;
Rpr = 0.4;
Rpf = 0.4;
Iwr = 0;
Iwf = 0;
%% Acquisition rate [Hz]
figure(1)
plot(data.acqrt)
ylabel('Acquisition rate [Hz]')
%%
data.normdata()
data.fft()
data.filter(5)
data.scale(1/g)
%% Acceleration [g]
figure(2)
plot(data.tnorm, data.data(:, 2))
xlabel('time [s]')
ylabel('Acceleration [g]')
grid on
%%
brake = BrakeClass(data.data(: ,2));
%%
brake.mudata(CG, L)
brake.dynreac(W, CG(1), CG(2), L)
brake.lockforce(W, CG(1), CG(2), L)
brake.btorque(Rpr, Rpf, Iwr, Iwf)

%%
figure(3)
plot(brake.mu)
xlabel('time [s]')
ylabel('\mu')
grid on
%%
figure(4)
plot(brake.Fz(:, 1), brake.Fz(:, 2))
xlabel('Fzf [N]')
ylabel('Fzf [N]')
grid on
%%
figure(5)
plot(brake.Tp(:, 1), brake.Tp(:, 2))
xlabel('Tpf [N]')
ylabel('Tpf [N]')
grid on
%%
