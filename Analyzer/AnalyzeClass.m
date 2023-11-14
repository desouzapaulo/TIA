%% Data Analyzer
classdef AnalyzeClass < handle
    properties
        folder = '';
        sensor = '';
        data = [];
        acqrt = [];
        w = [];
        A = [];
        fs = 0;
        tnorm = [];
    end
    methods
        %% Constructor
        function obj = AnalyzeClass(folder, sensor, fs)
            obj.folder = folder;
            obj.sensor = sensor;
            cd (folder)
            obj.fs = fs;
            % Accelerometer
            switch obj.sensor
                case "Accelerometer"
                    obj.data = csvread("Accelerometer.csv", 1);
                    obj.acqrt = 1./diff(obj.data(:, 2));   % Acquisition rate
            end
        end
        function normdata(obj)
            araw = obj.data(:,[5 4 3]);  % raw acceleration data
            traw = obj.data(:,2);    % raw time data
            obj.tnorm = 0:1/obj.fs:traw(end);
            obj.data = interp1(traw,araw,obj.tnorm,"spline","extrap"); % interpolate data through dt
        end
        function fft(obj)
            obj.w = linspace(0,obj.fs,numel(obj.tnorm));
            obj.A = fft(obj.data,[],1)/numel(obj.tnorm);
        end
        function filter(obj, cut)
            [c,d] = butter(2,cut*2/obj.fs,"low");
            obj.data = filtfilt(c,d,tukeywin(numel(obj.tnorm),0.2).*obj.data);
        end
        function scale(obj,factor)
            obj.data = obj.data.*factor;
        end
        function f = mu(obj, CG, L)
            a = obj.data(:, 2);
            f = a./(1-(CG(1)*a-CG(3))/L);
            for i = 1:length(a)
                if a(i) == 0
                    f(i) = 0;
                end
            end
        end
    end
end
