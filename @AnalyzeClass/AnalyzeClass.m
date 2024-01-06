%% Data Analyzer
classdef AnalyzeClass < handle
    properties
        folder string = string.empty;
        sensor string = string.empty;
        data double = double.empty;
        acqrt double = double.empty;
        w double = double.empty;
        A double = double.empty;
        fs double = double.empty;
        t double = double.empty;
    end
    methods
        %% Constructor
        function obj = AnalyzeClass(folder, sensor)
            obj.folder = folder;
            obj.sensor = sensor;
            cd (folder)
            switch obj.sensor
                case "Accelerometer"
                    obj.fs = 100;
                    obj.data = csvread("Accelerometer.csv", 1);
                    obj.acqrt = 1./diff(obj.data(:, 2));   % Acquisition rate
                    araw = obj.data(:,[5 4 3]);  % raw acceleration data
                    traw = obj.data(:,2);    % raw time data
                    obj.t = 0:1/obj.fs:traw(end);
                    obj.data = interp1(traw,araw,obj.t,"spline","extrap"); % interpolate data through dt
                case "Location"
                    obj.fs = 1;
                    obj.data = csvread("Location.csv", 1);
                    obj.acqrt = 1./diff(obj.data(:, 2));   % Acquisition rate
                case "PIG"
                    obj.fs = 2000;
                    obj.data = readmatrix("PIG_acc.csv");
                    obj.t = readmatrix("PIG_time.csv");
            end
        end
        function fft(obj)
            obj.w = linspace(0,obj.fs,numel(obj.t));
            obj.A = fft(obj.data,[],1)/numel(obj.t);
        end
        function filter(obj, cut)
            [c,d] = butter(2,cut*2/obj.fs,"low");
            obj.data = filtfilt(c,d,tukeywin(numel(obj.t),0.2).*obj.data);
        end
        function scale(obj, factor)
            obj.data = obj.data.*factor;
        end
        function scalereverse(obj,factor)
            obj.data = obj.data./factor;
        end
        function SensorCorrect(~)
            error('Not implemented yet.')
        end
        end
end

