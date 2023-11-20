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
        function obj = BrakeClass(a, t, g, CG, L, M, Rp, IM, Rext, Hp, mup, Acp, Acm, Hr)
            obj.a = a;
            obj.t = t;
            phi = CG(1) / L;
            X = CG(3) / L;
            %% coefficient of friction
            obj.mu = obj.a./((1 - (phi + X.*obj.a)).*g);
            %% dynamic reaction on Mheels
            Fzr = (phi - obj.a.*X).*M;
            Fzf = (1 - phi + obj.a.*X).*M;
            obj.Fz = [Fzf Fzr];
            %% locking forces
            Fxr = (phi + obj.a.*X).*(obj.a.*M);
            Fxf = (1 - phi + obj.a.*X).*(obj.a.*M);
            obj.Fx = [Fxf Fxr];
            %% brake torque
            obj.Tp = (obj.Fx*transpose(Rp)) + IM;
            %% friction forces on the caliper
            Ref = Rext - (Hp./2);
            obj.Fp = obj.Tp./Ref;
            %% hidraulic pressure
            obj.Ph = obj.Fp./(Acp*mup);
            %% master cylinder forces
            obj.Fcm = obj.Ph.*Acm;
            %% brake pedral force
            Ft = obj.Fcm(:, 1) + obj.Fcm(:, 2);
            obj.Fpedal = Ft.*Hr;
        end
        function acc(obj, n)
            figure(n)
            plot(obj.t, obj.a)
            xlabel('time [s]')
            ylabel('Acceleration [g]')
            grid on
        end
        function mudata(obj, n)
            figure(n)
            plot(obj.t, obj.mu)
            xlabel('time [s]')
            ylabel('\mu')
            grid on
        end
        function dynreac(obj, n)
            figure(n)
            plot(obj.t, obj.Fz(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fz(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fz [N]')
            grid on
        end
        function lockforce(obj, n)
            figure(n)
            plot(obj.t, obj.Fx(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fx(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fx [N]')
            grid on
        end
        function btorque(obj, n)
            figure(n)
            plot(obj.t, obj.Tp(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Tp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Tp [Nm]')
            grid on
        end
        function frictionforce(obj, n)
            figure(n)
            plot(obj.t, obj.Fp(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fp [N]')
            grid on
        end
        function hydpressure(obj, n)
            figure(n)
            plot(obj.t, obj.Ph(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Ph(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Ph [Pa]')
            grid on
        end
        function cylinderforce(obj, n)
            figure(n)
            plot(obj.t, obj.Fcm(:, 1), 'b-')
            hold all
            plot(obj.t, obj.Fcm(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fcm [N]')
            grid on
        end
        function pedalforce(obj, n)
            figure(n)
            plot(obj.t, obj.Fpedal, 'b-')
            xlabel('time [s]')
            ylabel('Fpedal [N]')
            grid on
        end
    end
end