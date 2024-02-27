classdef AccClass < handle
    properties
        R ReadClass = ReadClass.empty
        G GyroscopeClass = GyroscopeClass.empty
        C double = double.empty
        logger = "";
    end
    methods 
        function obj = AccClass(folder, logger)
            obj.logger = logger;
            switch obj.logger
                case "Phone"
                    obj.R = ReadClass(folder, "Accelerometer");
                    obj.G = GyroscopeClass(folder);
                case "PIG"
                    obj.R = ReadClass(folder, "PIG");              
                    obj.R.filter(100)
            end
        end
        function correctCG(obj)
            switch obj.logger
                case "Phone"
                    error('CG correction not implemented yet.')
            end
        end
    end
end