classdef AccClass < handle
    properties
       Read ReadeadClass = ReadeadClass.empty
        G GyroscopeClass = GyroscopeClass.empty
        C double = double.empty
        logger = '';
    end
    methods 
        function obj = AccClass()
            switch obj.logger
                case "Phone"
                    obj.Read =ReadeadClass();
                    obj.Read.sensor = "Accelerometer";                    
                    obj.G = GyroscopeClass();
                    obj.G.Read.sensor = "Accelerometer";
                    obj.G.Read.folder = obj.folder;
                case "PIG"
                    obj.Read = ReadeadClass();
                    obj.Read.sensor = "PIG";
                    obj.Read.filter(100)
                case "SET"
                    obj.Read = ReadeadClass();
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