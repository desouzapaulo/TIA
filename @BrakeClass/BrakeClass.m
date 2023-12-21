classdef BrakeClass < handle
    properties
    data AnalyzeClass = AnalyzeClass.empty
    mu double = double.empty;
    Fz double = double.empty;
    Fx double = double.empty;
    Tp double = double.empty;
    Re double = double.empty;
    Fp double = double.empty;
    Ph double = double.empty;
    Fcm double = double.empty;
    Fpedal double = double.empty;
    end
    %% constructor
    methods
        function obj = BrakeClass(folder, sensor, CG, L, W, Rp, IW, Rext, Hp, mup, Acp, Acm, Hr)
            %% base data
            obj.data = AnalyzeClass(folder, sensor);
            %obj.data.SensorCorrect()
            obj.data.fft()
            switch obj.data.sensor
                case "Accelerometer"
                    obj.data.filter(5)
                    obj.data.scale(1/9.81)
                case "PIG"
                    obj.data.filter(100)
            end
            %% parameters of the center of gravity
            phi = CG(1) / L;
            X = CG(3) / L;
            %% dynamic reaction on Wheels
            Fzr = (phi - X.*obj.data.data(:, 2)).*W;
            Fzf = (1 - phi + X.*obj.data.data(:, 2)).*W;
            obj.Fz = [Fzf Fzr];
            %% locking forces
            Fxr = (phi + X.*obj.data.data(:, 2)).*(obj.data.data(:, 2).*W);
            Fxf = (1 - phi + X.*obj.data.data(:, 2)).*(obj.data.data(:, 2).*W);
            obj.Fx = [Fxf Fxr];
            %% coefficient of friction
            obj.mu = obj.Fx./obj.Fz;
            %% brake torque
            obj.Tp = (obj.Fx.*Rp) + IW.*(obj.data.data(:, 2)./Rp);
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
        function acc(obj)
            figure
            plot(obj.data.t, obj.data.data(:, 2))
            xlabel('time [s]')
            ylabel('Acceleration [g]')
            grid on
        end
        function mudata(obj)
            figure()
            hold all
            plot(obj.data.t, obj.mu)
            xlabel('time [s]')
            ylabel('\mu')
            legend('front', 'rear')
            grid on
        end
        function dynreac(obj)
            figure
            hold all
            plot(obj.data.t, obj.Fz)
            xlabel('time [s]')
            ylabel('Dynamic Reaction [N]')
            legend('front', 'rear')
            grid on
        end
        function lockforce(obj)
            figure
            hold all
            plot(obj.data.t, obj.Fx(:, 1), 'b-')
            plot(obj.data.t, obj.Fx(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Loking Force [N]')
            legend('front', 'rear')
            grid on
        end
        function btorque(obj)
            figure
            hold all
            plot(obj.data.t, obj.Tp(:, 1), 'b-')
            plot(obj.data.t, obj.Tp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Brake Torque [Nm]')
            legend('front', 'rear')
            grid on
        end
        function frictionforce(obj)
            figure
            hold all
            plot(obj.data.t, obj.Fp(:, 1), 'b-')
            plot(obj.data.t, obj.Fp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Friction Force [N]')
            legend('front', 'rear')
            grid on
        end
        function hydpressure(obj)
            figure
            hold all
            plot(obj.data.t, obj.Ph(:, 1), 'b-')
            plot(obj.data.t, obj.Ph(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Hydraulic pressure [Pa]')
            legend('front', 'rear')
            grid on
        end
        function cylinderforce(obj)
            figure
            hold all
            plot(obj.data.t, obj.Fcm(:, 1), 'b-')
            plot(obj.data.t, obj.Fcm(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fcm [N]')
            grid on
        end
        function pedalforce(obj)
            figure
            hold all
            plot(obj.data.t, obj.Fpedal, 'b-')
            xlabel('time [s]')
            ylabel('Fpedal [N]')
            grid on
        end
        function avgmu(obj, a, b)
            % range a:b in seconds
            figure
            hold all
            histogram(obj.mu(a*obj.data.fs:b*obj.data.fs, 1), 'Normalization', 'probability');
            xlabel('\mu front');
            ylabel('Probabilidade');
            figure(n+1)
            histogram(obj.mu(a*obj.data.fs:b*obj.data.fs, 2), 'Normalization', 'probability');
            xlabel('\mu rear');
            ylabel('Probabilidade');
        end
        function avgacc(obj, a, b)
            figure
            hold all
            histogram(obj.data.data(a*obj.data.fs:b*obj.data.fs, 2), 'Normalization', 'probability');
            
        end
        function distn(obj, a, b, type)
            switch type
                case 'mu'
                    figure
                    histfit(obj.mu(a*obj.data.fs:b*obj.data.fs, 1), 50, 'Normal')
                    xlabel('Dados [\mu]');
                    ylabel('Frequência');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    title('Front \mu')
                    figure
                    histfit(obj.mu(a*obj.data.fs:b*obj.data.fs, 2),50,'Normal');
                    xlabel('Dados [\mu]');
                    ylabel('Frequência');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    title('Rear \mu')
                    figure
                    qqplot(obj.mu(a*obj.data.fs:b*obj.data.fs, 1))
                    title('Front')
                    figure
                    qqplot(obj.mu(a*obj.data.fs:b*obj.data.fs, 2))
                    title('Rear')
                case 'acc'
                    figure
                    histfit(obj.data.data(a*obj.data.fs:b*obj.data.fs, 2),50,'Normal');
                    xlabel('Data [acc]');
                    ylabel('Frequency');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    figure
                    qqplot(obj.data.data(a*obj.data.fs:b*obj.data.fs, 2));
                    title('Acc data')
                    
                
            end
        end
    end
end