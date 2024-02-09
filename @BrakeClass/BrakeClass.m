classdef BrakeClass < handle
    properties
    Acc AccClass = AccClass.empty
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
            obj.Acc = AccClass(folder, logger);
        end
            %% dynamic reaction on Wheels
            function calcFz(obj, phi, X, m)
                W = m*9.81;
                Fzr = (phi - X.*obj.Acc.read.data(:, 2)).*W;
                Fzf = (1 - phi + X.*obj.Acc.read.data(:, 2)).*W;
                obj.Fz = [Fzf Fzr];
            end
            %% locking forces
            function calcFx(obj, phi, X, m)
                W = m*9.81;
                Fxr = (phi + X.*obj.Acc.read.data(:, 2)).*(obj.Acc.read.data(:, 2).*W);
                Fxf = (1 - phi + X.*obj.Acc.read.data(:, 2)).*(obj.Acc.read.data(:, 2).*W);
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
                obj.Tp = (obj.Fx.*Rp) + IW.*(obj.Acc.read.data(:, 2)./Rp);
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
                obj.Fpedal = (obj.Fcm(:, 1) + Hr.*obj.Fcm(:, 2));
            end
            
        %% plots
        function pltAcc(obj)
            figure
            plot(obj.Acc.read.t, obj.Acc.read.data(:, 2))
            xlabel('time [s]')
            ylabel('Acceleration [g]')
            grid on
        end
        function pltmu(obj)
            figure()
            hold all
            plot(obj.Acc.read.t, obj.mu)
            xlabel('time [s]')
            ylabel('\mu')
            legend('front', 'rear')
            grid on
        end
        function pltFz(obj)
            figure
            hold all
            plot(obj.Acc.read.t, obj.Fz)
            xlabel('time [s]')
            ylabel('Dynamic Reaction [N]')
            legend('front', 'rear')
            grid on
        end
        function pltFx(obj)
            figure
            hold all
            plot(obj.Acc.read.t, obj.Fx(:, 1), 'b-')
            plot(obj.Acc.read.t, obj.Fx(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Loking Force [N]')
            legend('front', 'rear')
            grid on
        end
        function pltTp(obj)
            figure
            hold all
            plot(obj.Acc.read.t, obj.Tp(:, 1), 'b-')
            plot(obj.Acc.read.t, obj.Tp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Brake Torque [Nm]')
            legend('front', 'rear')
            grid on
        end
        function pltFp(obj)
            figure
            hold all
            plot(obj.Acc.read.t, obj.Fp(:, 1), 'b-')
            plot(obj.Acc.read.t, obj.Fp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Friction Force [N]')
            legend('front', 'rear')
            grid on
        end
        function pltPh(obj)
            figure
            hold all
            plot(obj.Acc.read.t, (obj.Ph(:, 1))*1E-5, 'b-')
            plot(obj.Acc.read.t, (obj.Ph(:, 2))*1E-5, 'r-')
            xlabel('time [s]')
            ylabel('Hydraulic pressure [Bar]')
            legend('front', 'rear')
            grid on
        end
        function pltFcm(obj)
            figure
            hold all
            plot(obj.Acc.read.t, obj.Fcm(:, 1), 'b-')
            plot(obj.Acc.read.t, obj.Fcm(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fcm [N]')
            grid on
        end
        function pltFpedal(obj)
            figure
            hold all
            plot(obj.Acc.read.t, (obj.Fpedal)/9.81, 'b-')
            xlabel('time [s]')
            ylabel('Fpedal [Kg]')
            grid on
        end
        function pltavgmu(obj, a, b)
            % range a:b in seconds
            figure
            hold all
            histogram(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 1), 'Normalization', 'probability');
            xlabel('\mu front');
            ylabel('Probabilidade');
            figure(n+1)
            histogram(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 2), 'Normalization', 'probability');
            xlabel('\mu rear');
            ylabel('Probabilidade');
        end
        function pltavgacc(obj, a, b)
            figure
            hold all
            histogram(obj.Acc.read.data(a*obj.Acc.fs:b*obj.Acc.fs, 2), 'Normalization', 'probability');
            
        end
        function pltdistn(obj, a, b, datatype)
            switch datatype
                case 'mu'
                    figure
                    histfit(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 1), 50, 'Normal')
                    xlabel('Dados [\mu]');
                    ylabel('Frequência');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    title('Front \mu')
                    figure
                    histfit(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 2),50,'Normal');
                    xlabel('Dados [\mu]');
                    ylabel('Frequência');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    title('Rear \mu')
                    figure
                    qqplot(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 1))
                    title('Front')
                    figure
                    qqplot(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 2))
                    title('Rear')
                case 'acc'
                    figure
                    histfit(obj.Acc.read.data(a*obj.Acc.fs:b*obj.Acc.fs, 2),50,'Normal');
                    xlabel('Data [acc]');
                    ylabel('Frequency');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    figure
                    qqplot(obj.Acc.read.data(a*obj.Acc.fs:b*obj.Acc.fs, 2));
                    title('Acc.read.data')
                    
                
            end
        end
    end
end