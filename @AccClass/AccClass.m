classdef AccClass < handle
    properties
        data ReadClass = ReadClass.empty
        Gyr GyroscopeClass = GyroscopeClass.empty
        sensorposition double = double.empty
    end
    methods 
        function obj = AccClass(folder, logger)
            
            
            switch logger
                case "Phone"
                    acc = ReadClass(folder, "Accelerometer");
                    gyr = GyroscopeClass(folder);
                    obj.data = acc + gyr.data.*(gyr.data.*obj.sensorposition) + gyr.acc.*obj.sensorposition;
                    obj.data.fft()
                    obj.data.filter(5)
                    obj.data.scale(1/9.81)
                    
                case "PIG"
                    obj.data = ReadClass(folder, "PIG");              
                    obj.data.filter(100)
            end
            
            
        end
    end
end