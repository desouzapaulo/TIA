classdef LocationClass < handle
    properties
        t = []
        speed_data = [];
    end
    methods
        function obj = LocationClass(t, speed)
            obj.t = t;
            obj.speed_data = speed;
        end
        function speed(obj, n)
            figure(n)
            plot(obj.t, obj.speed_data)
            xlabel('time [s]')
            ylabel('Speed [m/s]')
            grid on
        end
    end
end