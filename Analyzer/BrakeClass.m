classdef BrakeClass < handle
    properties
    mu = [];
    a = [];
    Fz = [];
    Fx = [];
    Tp = [];
    Re = [];
    Fp =[];
    Ph = [];
    Fcm = [];
    Fpilot = [];
    end

    methods
        function obj = BrakeClass(data)
            obj.a = data;
        end
        function mudata(obj, CG, L)
            obj.mu = obj.a./(1-(CG(1)*obj.a-CG(3))/L);
        end
        function dynreac(obj, W, CGx, CGz, L)
            phi = CGz / L;
            X = CGx / L;
            Fzr = (phi - obj.a.*X) * W;
            Fzf = (1 - phi + obj.a.*X) * W;
            obj.Fz = [Fzf, Fzr];
        end
        function lockforce(obj, W, CGx, CGz, L)
            phi = CGz / L;
            X = CGx / L;
            Fxr = (phi + obj.a.*X).*(obj.a.* W);
            Fxf = (1 - phi + obj.a.*X).*(obj.a.* W);
            obj.Fx = [Fxf, Fxr];
        end
        function btorque(obj, Rpr, Rpf, Iwr, Iwf)
            Tpf = obj.Fx(1).*Rpf + Iwf;
            Tpr = obj.Fx(2).*Rpr + Iwr;
            obj.Tp = [Tpf, Tpr];
        end
    end
end