classdef LocationClass < handle
    properties
        data ReadClass = ReadClass.empty
        v double = double.empty;
        lat double = double.empty;
        long doule = double.empty;
    end
    methods
        %% Constructor
        function obj = LocationClass(folder)
            obj.data = ReadClass(folder, "Location");
        end
        %% Velocity
        function calcVelo(obj)
            obj.v = obj.data.data(:, 7).*3.6; % Km/h
        end
        function calcTrack(obj)
            obj.lat = obj.data.data(:, 10);
            obj.long = obj.data.data(:, 11);
        end
        %% Plots
        function plotvelo(obj, n)
            figure(n)
            plot(obj.data.data(:, 2), obj.v)
            xlabel('time [s]')
            ylabel('Speed [km/h]')
            grid on
        end
        function plttrack(obj)
            figure()
            plot(obj.lat, obj.long);
            xlabel('Latitude')
            ylabel('Longitude')
            grid on
        end
    end
end