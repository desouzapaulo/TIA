classdef BrakeClass < handle
    properties
    data ReadClass = ReadClass.empty
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
        function obj = BrakeClass(folder, logger)
            switch logger
                case "Phone"
                    obj.data = ReadClass(folder, "Accelerometer");
                    obj.data.fft()
                    obj.data.filter(5)
                    obj.data.scale(1/9.81)
                case "PIG"
                    obj.data = ReadClass(folder, "PIG");
                    obj.data.filter(100)
            end  
        end
            %% dynamic reaction on Wheels
            function calcFz(obj, phi, X, m)
                W = m*9.81;
                Fzr = (phi - X.*obj.data.data(:, 2)).*W;
                Fzf = (1 - phi + X.*obj.data.data(:, 2)).*W;
                obj.Fz = [Fzf Fzr];
            end
            %% locking forces
            function calcFx(obj)
                Fxr = (phi + X.*obj.data.data(:, 2)).*(obj.data.data(:, 2).*W);
                Fxf = (1 - phi + X.*obj.data.data(:, 2)).*(obj.data.data(:, 2).*W);
                obj.Fx = [Fxf Fxr];
            end
            %% coefficient of friction
            function calcmu(obj)
                obj.mu = obj.Fx./obj.Fz;
            end
            %% brake torque
            function calcTp(obj, RpF, RpR, IWF, IWR)
                IW = [IWF IWR];
                Rp = [RpF RpR];
                obj.Tp = (obj.Fx.*Rp) + IW.*(obj.data.data(:, 2)./Rp);
            end
            %% friction forces on the caliper
            function calcFp(obj, RextF, RestR, HpF, HpR)
                Rext = [RextF RestR];
                Hp = [HpF HpR];
                Ref = Rext - (Hp./2);
                obj.Fp = obj.Tp./Ref;
            end
            %% hidraulic pressure
            function calcPh(obj, Acp, mup)
                obj.Ph = obj.Fp./(Acp*mup);
            end
            %% master cylinder forces
            function calcFcm(obj, Acm)
                obj.Fcm = obj.Ph.*Acm;
            end
            %% brake pedral force
            function calcFpedal(obj, Hr)
                obj.Fpedal = (obj.Fcm(:, 1) + obj.Fcm(:, 2)).*Hr;
            end
            
        %% plots
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
            plot(obj.data.t, (obj.Ph(:, 1))*1E-5, 'b-')
            plot(obj.data.t, (obj.Ph(:, 2))*1E-5, 'r-')
            xlabel('time [s]')
            ylabel('Hydraulic pressure [Bar]')
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
            plot(obj.data.t, (obj.Fpedal)/9.81, 'b-')
            xlabel('time [s]')
            ylabel('Fpedal [Kg]')
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
        function distn(obj, a, b, datatype)
            switch datatype
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