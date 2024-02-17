classdef GyroscopeClass < handle
    properties
        read ReadClass = ReadClass.empty
        alpha double = double.empty
        w double = double.empty
    end
    methods
        function obj = GyroscopeClass(folder)
            obj.read = ReadClass(folder, "Gyroscope");
            obj.w = obj.read.data(:, 4); % y
            obj.alpha = [diff(obj.w); 0];

        end
    end
end