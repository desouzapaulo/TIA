close all
clear
clc
%%
folder1 = '/Paulo (bolsista)/Data_Analyzer/data/Logger_formula_1';
folder2 = '/Paulo (bolsista)/Data_Analyzer/data/Logger_formula_2';
folder3 = '/Paulo (bolsista)/Data_Analyzer/data/Rollout_teste_cruze';
sensor = "Accelerometer";
Aq = 100; % Hz
%%
data = AnalyzeClass(folder3, sensor, Aq);
CG = [0.9 0.0 0.25];                
L = 1.55;   
g = 9.81;
%% Acquisition rate [Hz]
figure(1)
plot(data.acqrt)
ylabel('Acquisition rate [Hz]')
%%
data.normdata()
data.fft()
data.filter(10)
data.scale(1/g)
mu = data.mu(CG, L);
%% Acceleration [g]
figure(2)
plot(data.tnorm, data.data(:, 2))
xlabel('time [s]')
ylabel('Acceleration [g]')
%% Coefficient of friction
figure(3)
plot(data.tnorm, mu)
xlabel('Time [s]')
ylabel('\mu')