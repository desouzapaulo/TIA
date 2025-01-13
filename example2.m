close all
clear all
clc
% ======================================INPUT=================================================
%% Load files
folder = "C:\Users\paulo\Desktop\TIA\data\Phone\formula-2";
logger = "PHONE";
filename = "C:\Users\paulo\Desktop\TIA\parameters\RS11.xlsx";
parameters = readmatrix(filename);
BBB = 0.45; % for the rear
psi = 0.55;
chi = 0.2;
acc = 0.85;
% ======================================OUTPUT================================================
%% Initial
brake = BrakeClass(folder, logger);
brake.Acc.Read.section(29.5, 31)
brake.ReadParameters(psi, chi, BBB, parameters);

brake.solveOptBrake
brake.solveRealBrake
brake.solvemu_real
brake.solvemu_optm
brake.solveFpedal(acc)
brake.solvemu(acc)
brake.solvemu_real
brake.solvemu_optm
brake.solveCntFriction
brake.solveBrakeEff
brake.solvemu(0.9)

% figure
% hold all
% grid minor
% grid on
% xlabel("Time [s]")
% ylabel("Line pressure [bar]")
% plot(brake.Acc.Read.t, brake.Pl_optm(:, 1).*0.1, DisplayName="Front Optimum Pressure")
% plot(brake.Acc.Read.t, brake.Pl_optm(:, 2).*0.1, DisplayName="Rear Optimum Pressure")
% legend("Location","best")
% 
figure
hold all
grid minor
grid on
xlabel("Time [s]")
ylabel("Acc [g units]")
plot(brake.Acc.Read.t, brake.a)

disp(brake.mu_T)
