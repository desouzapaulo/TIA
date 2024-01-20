classdef GyroscopeClass < handle
    properties
        data double = double.empty
        acc double = double.empty
    end
    methods
        function obj = GyroscopeClass(folder)
            obj.data = ReadClass(folder, "Gyroscope");
            obj.acc = diff(data);
        end
    end
end