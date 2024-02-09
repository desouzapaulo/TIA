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
                    obj.read.fft()
                    obj.read.filter(5)
                    obj.read.scale(1/9.81)
                    
                case "PIG"
                    obj.read = ReadClass(folder, "PIG");              
                    obj.read.filter(100)
            end
        end
        function correctCG(obj)
            switch obj.logger
                case "Phone"
                    obj.read.data(:, 1) = obj.read.data(:, 1) + obj.gyr.w.*(obj.gyr.w*obj.C(1)) + obj.gyr.alpha.*obj.C(1);
                    obj.read.data(:, 2) = obj.read.data(:, 2) + obj.gyr.w.*(obj.gyr.w*obj.C(2)) + obj.gyr.alpha.*obj.C(2);
                    obj.read.data(:, 3) = obj.read.data(:, 3) + obj.gyr.w.*(obj.gyr.w*obj.C(3)) + obj.gyr.alpha.*obj.C(3);
            end
        end
    end
end