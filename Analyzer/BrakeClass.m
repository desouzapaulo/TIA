classdef BrakeClass < handle
    properties
    t = [];
    mu = [];
    a = [];
    Fz = [];
    Fx = [];
    Tp = [];
    Re = [];
    Fp =[];
    Ph = [];
    Fcm = [];
    Fpedal = [];
    end
    %% constructor
    methods
        function obj = BrakeClass(data, t, CG, L, W, Rp, Iw, Rext, Hp, mup, Acp, Acm, Hr)
            obj.a = data;
            obj.t = t;
            %%
            obj.mu = obj.a./(1-(CG(1)*obj.a-CG(3))/L);
            %%
            phi = CG(2) / L;
            X = CG(1) / L;
            Fzr = (phi - obj.a.*X) * W;
            Fzf = (1 - phi + obj.a.*X) * W;
            obj.Fz = [Fzf, Fzr];
            %%
            phi = CG(2) / L;
            X = CG(1) / L;
            Fxr = (phi + obj.a.*X).*(obj.a.* W);
            Fxf = (1 - phi + obj.a.*X).*(obj.a.* W);
            obj.Fx = [Fxf, Fxr];
            %%
            obj.Tp = obj.Fx.*Rp + Iw;
            %%
            Ref = Rext - (Hp./2);
            obj.Fp = obj.Tp./Ref;
            %%
            obj.Ph = obj.Fp./(Acp*mup);
            %%
            obj.Fcm = obj.Ph.*Acm;
            %%
            Ft = obj.Fcm(:, 1) + obj.Fcm(:, 2);
            obj.Fpedal = Ft.*Hr;
        end
        function acc(obj)
            plot(obj.t, obj.a)
            xlabel('time [s]')
            ylabel('Acceleration [g]')
            grid on
        end
        function mudata(obj)
            plot(obj.t, obj.mu)
            xlabel('time [s]')
            ylabel('\mu')
            grid on
        end
        function dynreac(obj)
            plot(obj.t, obj.Fz(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fz(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fz [N]')
            grid on
        end
        function lockforce(obj)
            plot(obj.t, obj.Fx(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fx(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fx [N]')
            grid on
        end
        function btorque(obj)
            plot(obj.t, obj.Tp(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Tp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Tp [Nm]')
            grid on
        end
        function frictionforce(obj)
            plot(obj.t, obj.Fp(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fp [N]')
            grid on
        end
        function hydpressure(obj)
            plot(obj.t, obj.Ph(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Ph(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Ph [Pa]')
            grid on
        end
        function cylinderforce(obj)
            plot(obj.t, obj.Fcm(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fcm(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fcm [N]')
            grid on
        end
        function pedalforce(obj)
            plot(obj.t, obj.Fpedal, 'b-')
            xlabel('time [s]')
            ylabel('Fpedal [N]')
            grid on
        end
    end
end