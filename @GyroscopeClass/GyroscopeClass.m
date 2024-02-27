classdef GyroscopeClass < handle
    properties
        R ReadClass = ReadClass.empty
        alpha double = double.empty
    end
    methods
        function obj = GyroscopeClass(folder)
            obj.R = ReadClass(folder, "Gyroscope");
        end
    end
end