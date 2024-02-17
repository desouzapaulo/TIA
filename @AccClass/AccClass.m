classdef AccClass < handle
    properties
        read ReadClass = ReadClass.empty
        gyr GyroscopeClass = GyroscopeClass.empty
        C double = double.empty
        logger = "";
    end
    methods 
        function obj = AccClass(folder, logger)
            obj.logger = logger;
            switch obj.logger
                case "Phone"
                    obj.read = ReadClass(folder, "Accelerometer");
                    obj.gyr = GyroscopeClass(folder);
                    
                case "PIG"
                    obj.read = ReadClass(folder, "PIG");              
                    obj.read.filter(100)
            end
        end
        function correctCG(obj)
            switch obj.logger
                case "Phone"
                    index = (size(obj.read.data, 1) - size(obj.gyr.w, 1)) + 1;
                    obj.read.data = obj.read.data(index:end, :);
                    obj.read.t = obj.read.t(:, index:end);
                    obj.read.data(:, 1) = obj.read.data(:, 1) + obj.gyr.w.*(obj.gyr.w*obj.C(1)) + obj.gyr.alpha.*obj.C(1); % z
                    obj.read.data(:, 2) = obj.read.data(:, 2) + obj.gyr.w.*(obj.gyr.w*obj.C(2)) + obj.gyr.alpha.*obj.C(2); % y
                    obj.read.data(:, 3) = obj.read.data(:, 3) + obj.gyr.w.*(obj.gyr.w*obj.C(3)) + obj.gyr.alpha.*obj.C(3); % x
            end
        end
    end
end