classdef LocationClass < handle
    properties
        data ReadClass = ReadClass.empty
    end
    methods
        function obj = LocationClass(folder, sensor)
            obj.data = ReadClass(folder, sensor);
        end
        function speed(obj, n)
            figure(n)
            plot(obj.data.data(:, 2), obj.data.data(:, 7).*3.6)
            xlabel('time [s]')
            ylabel('Speed [km/h]')
            grid on
        end
        function track(obj, n)
            figure(n)
            plot(obj.data.data(:, 10), obj.data.data(:, 11));
            xlabel('Latitude')
            ylabel('Longitude')
            grid on
        end
    end
end