clear all
close all
clc

path = '\\gend-servdados\Pessoal\paulo-bolsista\PIG\T2\';
p = PIGDataReadClass(path);
time = (0:(size(p.ACC(:,1),1)-1)) / p.Configuration.FsAcc;

writematrix(p.ACC, 'PIG_acc.csv')
writematrix(time, 'PIG_time.csv')


figure(1);clf;
hold all
plot(time,p.ACC(:,1))
plot(time,p.ACC(:,2))
plot(time,p.ACC(:,3))        
