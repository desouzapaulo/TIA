classdef GyroscopeClass < handle
    properties
        R ReadClass = ReadClass.empty
        alpha double = double.empty
    end
    methods
        function obj = GyroscopeClass()
            obj.R = ReadClass();
            obj.R.sensor = "Gyroscope";
        end
    end
end