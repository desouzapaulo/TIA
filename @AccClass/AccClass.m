classdef AccClass < handle
    properties
        Read ReadClass    = ReadClass.empty
        G GyroscopeClass  = GyroscopeClass.empty
        C double          = double.empty
        folder = '';
        logger = '';
        sensor = '';
    end
    methods 
        function obj = AccClass(folder, logger)
            obj.folder = folder;
            obj.logger = logger;
            switch obj.logger
                case "Phone"
                    obj.sensor = "Accelerometer";
                    obj.Read = ReadClass(obj.folder, obj.sensor);                 
                case "PIG"
                    obj.Read = ReadeadClass(obj.folder, obj.logger);
                    obj.Read.sensor = "PIG";
                    obj.Read.filter(100)
                case "SET"
                    obj.Read = ReadClass(obj.folder, obj.logger);
                    obj.Read.folder = "NONE";
                    obj.Read.sensor = "SET";
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