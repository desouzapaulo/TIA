classdef ReadClass < handle
    properties
        folder = '';
        sensor = '';
        data double = double.empty;
        acqrt double = double.empty;
        w double = double.empty;
        A double = double.empty;
        fs double = double.empty;
        t double = double.empty;      
    end
    methods
        %% Constructor
        function obj = ReadClass(folder, sensor)    
            obj.folder  = folder;
            obj.sensor = sensor;
            switch obj.sensor
                case "Accelerometer"
                    cd(obj.folder)
                    obj.fs = 100;
                    obj.data = readmatrix("Accelerometer.csv");
                    obj.acqrt = 1./diff(obj.data(:, 2));   % Acquisition rate
                    araw = obj.data(:,[5 4 3]);
                    traw = obj.data(:,2); 
                    normalize(araw, traw)
                case "Location"
                    cd(obj.folder)
                    obj.fs = 1;
                    obj.data = readmatrix("Location.csv");
                    obj.acqrt = 1./diff(obj.data(:, 2));   % Acquisition rate
                case "PIG"
                    cd(obj.folder)
                    obj.fs = 2000;
                    obj.data = readmatrix("PIG_acc.csv");
                    obj.t = readmatrix("PIG_time.csv");
                case "Gyroscope"
                    cd(folder)
                    obj.fs = 100; %conferir
                    obj.data = readmatrix("Gyroscope.csv");
                    obj.acqrt = 1./diff(obj.data(:, 2));   % Acquisition rates
                    araw = obj.data(:,[5 4 3]);  % raw acceleration data
                    traw = obj.data(:,2);    % raw time data
                    normalize(araw, traw)
                case "SET"
                    obj.fs = 100;
                    step = 1/obj.fs;
                    period = 5; % seconds
                    limit = 1.5; % g
                    obj.t = 0:step:period;
                    obj.data = zeros(numel(obj.t), 3);                    
                    el = 0:(limit/(numel(obj.t)-1)):limit;
                    obj.data(:, 2) = el'; 
            end
        end
        %% Intepol
        function normalize(obj, araw, traw)
            obj.t = 0:1/obj.fs:traw(end);
            obj.data = interp1(traw,araw,obj.t,"spline","extrap"); % interpolate data through dt
        end
        %% FFT analizys
        function fft(obj)
            obj.w = linspace(0,obj.fs,numel(obj.t));
            obj.A = fft(obj.data,[],1)/numel(obj.t);
        end
        %% Low pass filter
        function filter(obj, cut)
            [c,d] = butter(2,cut*2/obj.fs,"low");
            obj.data = filtfilt(c,d,tukeywin(numel(obj.t),0.2).*obj.data);
        end
        %% Scale data
        function scale(obj, factor)
            obj.data = obj.data.*factor;
        end
        %% Undo scale data
        function undoscale(obj,factor)
            obj.data = obj.data./factor;
        end
        %% section
        function section(obj, a, b)
            a = a * obj.fs;
            b = b * obj.fs;
            obj.data = obj.data(a:b, :);
            obj.t = obj.t(:, a:b);
        end
        end
end

