classdef GyroscopeClass < handle
    properties
        data double = double.empty
        acc double = double.empty
    end
    methods
        function obj = GyroscopeClass(folder, sensor)
            obj.data = ReadClass(folder, sensor);
            obj.acc = diff(data);
        end
    end
end