classdef GyroscopeClass < handle
    properties
        read ReadClass = ReadClass.empty
        alpha double = double.empty
        w double = double.empty
    end
    methods
        function obj = GyroscopeClass(folder)
            obj.read = ReadClass(folder, "Gyroscope");
            obj.w = obj.read.data(:, 4);
            obj.alpha = diff(obj.w);
        end
    end
end