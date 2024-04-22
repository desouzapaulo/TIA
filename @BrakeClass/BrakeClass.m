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
    W double = double.empty;
    phi double = double.empty;
    X double = double.empty;
    Bl double = double.empty;
    g = 9.81;
    folder = '';
    logger = '';
    end
    %% constructor
    methods
        function obj = BrakeClass(folder, logger)
            obj.folder = folder;
            obj.logger = logger;
            obj.Acc = AccClass(obj.folder, obj.logger);            
        end
        %% dynamic reaction on Wheels
        function calcFz(obj, CG, L, m)
<<<<<<< HEAD
            obj.W = m*9.81;
            obj.phi = CG(1)/L;
            obj.X = CG(2)/L; 
            Fzr = (obj.phi - obj.X.*abs(obj.Acc.Read.data(:, 2))).*obj.W;
            Fzf = (1 - obj.phi + obj.X.*abs(obj.Acc.Read.data(:, 2))).*obj.W;
            obj.Fz = [Fzf Fzr];
        end
        %% Braking forces
        function calcFx(obj)        
            Fxr = (obj.phi - obj.X.*abs(obj.Acc.Read.data(:, 2))).*(abs(obj.Acc.Read.data(:, 2)).*obj.W);
            Fxf = (1 - obj.phi + obj.X.*abs(obj.Acc.Read.data(:, 2))).*(abs(obj.Acc.Read.data(:, 2)).*obj.W);
=======
            obj.W = m*obj.g;
            obj.phi = CG(1)/L;
            obj.X = CG(2)/L;        
            Fzf = (1 - obj.phi + obj.X.*(obj.Acc.Read.data(:, 2))).*obj.W;
            Fzr = (obj.phi - obj.X.*(obj.Acc.Read.data(:, 2))).*obj.W;
            obj.Fz = [Fzf Fzr];
        end
        %% Braking forces
        function calcFx(obj)
            Fxf = (1 - obj.phi + obj.X.*(obj.Acc.Read.data(:, 2))).*((obj.Acc.Read.data(:, 2)).*obj.W);
            Fxr = (obj.phi - obj.X.*(obj.Acc.Read.data(:, 2))).*((obj.Acc.Read.data(:, 2)).*obj.W);
>>>>>>> 0110fcdbf05832ae8e9580530351d46434ca797d
            obj.Fx = [Fxf Fxr];
        end            
        %% coefficient of friction
        function calcmu(obj)
            muf = (obj.Fx(:,1)./obj.Fz(:,1));
            mur = (obj.Fx(:,2)./obj.Fz(:,2));
            obj.mu = [muf mur];
        end
        %% Brake line
        function calcBL(obj)
            Blf = obj.Fx(:, 1)./obj.W;
            Blr = obj.Fx(:, 2)./obj.W;
            obj.Bl = [Blf Blr];
        end
        %% brake torque
        function calcTp(obj, RpF, RpR, IWF, IWR)
            IW = [IWF IWR];
            Rp = [RpF RpR];
            obj.Tp = (obj.Fx.*Rp) + IW.*(abs(obj.Acc.Read.data(:, 2).*obj.g)./Rp);
        end
        %% friction forces on the caliper
        function calcFp(obj, RextF, RextR, HpF, HpR)
            Rext = [RextF RextR];
            Hp = [HpF HpR];
            Ref = Rext - (Hp./2);
            obj.Fp = (obj.Tp./Ref).*0.5;
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
            obj.Fpedal = (obj.Fcm(:, 1)+obj.Fcm(:, 2)).*Hr;
        end
<<<<<<< HEAD
        %% Brake line
        function calcBL(obj)
            Blr = obj.Fx(:, 2)./obj.W;
            Blf = obj.Fx(:, 1)./obj.W;
            obj.Bl = [Blf Blr];
        end
=======
>>>>>>> 0110fcdbf05832ae8e9580530351d46434ca797d

        %% plots

        function pltfft(obj)
            figure
            hold all
            title('FFT')
            plot(obj.Acc.Read.w, obj.Acc.Read.A(:, 2))
            xlabel('Amplitude')
            ylabel('Frequency')
            grid on
        end

        function pltacqrt(obj)
            figure
            hold all
            title('')
            plot(obj.Acc.Read.acqrt)
            xlabel('Acquisition Rate')
            ylabel('Samples')
            grid on
        end
        function pltAcc(obj)
            figure
            hold all
            title('Acc')
            plot(obj.Acc.Read.t, obj.Acc.Read.data(:, 2))
            xlabel('time [s]')
            ylabel('Acceleration [g]')
            grid on
        end
        function pltmu(obj)
            figure
            hold all
            title('Traction coefficient')
            plot(obj.Acc.Read.t, obj.mu(:,1), '-b')
            plot(obj.Acc.Read.t, obj.mu(:,2), '-r')
            xlabel('time [s]')
            ylabel('\mu')
            legend('front', 'rear')
            grid on
        end
        function pltFz(obj)
            figure
            hold all
            title('Dynamic Reaction')
            plot(obj.Acc.Read.t, obj.Fz(:, 1), '-b')
            plot(obj.Acc.Read.t, obj.Fz(:, 2), '-r')
            xlabel('time [s]')
            ylabel('Dynamic Reaction [N]')
            legend('front', 'rear')
            grid on
        end
        function pltFx(obj)
            figure
            hold all
            title('Braking Forces')
            plot(obj.Acc.Read.t, obj.Fx(:, 1), 'b-')
            plot(obj.Acc.Read.t, obj.Fx(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Loking Force [N]')
            legend('front', 'rear')
            grid on
        end
        function pltbrakeline(obj)
            figure
            hold all
            title('Optimum Braking Line')
            title('Brake Curve')
            plot(obj.Bl(:,2), obj.Bl(:,1))
            % for i = 1:10
            %     i/10 = 
            %     a = -b./x;
            %     y = a.*x + b;
            %     plot(x, y)
            % end
            xlabel('Dynamic Rear Axle Brake Force (Normalized)')
            ylabel('Dynamic Front Axle Brake Force (Normalized)')
            grid on

        end
        function pltTp(obj)
            figure
            hold all
            title('')
            plot(obj.Acc.Read.t, obj.Tp(:, 1), 'b-')
            plot(obj.Acc.Read.t, obj.Tp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Brake Torque [Nm]')
            legend('front', 'rear')
            grid on
        end
        function pltFp(obj)
            figure
            hold all
            title('')
            plot(obj.Acc.Read.t, obj.Fp(:, 1), 'b-')
            plot(obj.Acc.Read.t, obj.Fp(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Friction Force [N]')
            legend('front', 'rear')
            grid on
        end
        function pltPh(obj)
            figure
            hold all
            title('')
            plot(obj.Acc.Read.t, (obj.Ph(:, 1))*1E-5, 'b-')
            plot(obj.Acc.Read.t, (obj.Ph(:, 2))*1E-5, 'r-')
            xlabel('time [s]')
            ylabel('Hydraulic pressure [Bar]')
            legend('front', 'rear')
            grid on
        end
        function pltFcm(obj)
            figure
            hold all
            title('')
            plot(obj.Acc.Read.t, obj.Fcm(:, 1), 'b-')
            plot(obj.Acc.Read.t, obj.Fcm(:, 2), 'r-')
            xlabel('time [s]')
            ylabel('Fcm [N]')
            legend('front', 'rear')
            grid on
        end
        function pltFpedal(obj)
            figure
            hold all
            title('')
            plot(obj.Acc.Read.t, abs((obj.Fpedal)/obj.g), 'b-')
            plot(obj.Acc.Read.t, (445/obj.g).*ones(1,numel(obj.Acc.Read.t)))
            plot(obj.Acc.Read.t, (823/obj.g).*ones(1,numel(obj.Acc.Read.t)))
            legend('Data', '5th percentile female', '95th percentile male')
            xlabel('time [s]')
            ylabel('Fpedal [Kg]')
            grid on
        end
<<<<<<< HEAD
        function pltBl(obj)
            figure
            hold all
            title('Brake Curve')
            plot(obj.Bl(:,2), obj.Bl(:,1))    
            xlabel('Dynamic Rear Axle Brake Force (Normalized)')
            ylabel('Dynamic Front Axle Brake Force (Normalized)')
            grid on
=======
>>>>>>> 0110fcdbf05832ae8e9580530351d46434ca797d

        %% Statistics
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
            histogram(obj.Acc.R.data(a*obj.Acc.fs:b*obj.Acc.fs, 2), 'Normalization', 'probability');
            
        end
        function pltdistn(obj, a, b, datatype)
            switch datatype
                case 'mu'
                    figure
                    histfit(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 1), 50, 'Normal')
                    xlabel('Dados [\mu]');
                    ylabel('Frequencia');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    title('Front \mu')
                    figure
                    histfit(obj.mu(a*obj.Acc.fs:b*obj.Acc.fs, 2),50,'Normal');
                    xlabel('Dados [\mu]');
                    ylabel('Frequencia');
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
                    histfit(obj.Acc.Read.data(a*obj.Acc.fs:b*obj.Acc.fs, 2),50,'Normal');
                    xlabel('Data [acc]');
                    ylabel('Frequency');
                    legend('Data', 'Normal Distribution', 'Location', 'NorthWest')
                    figure
                    qqplot(obj.Acc.Read.data(a*obj.Acc.fs:b*obj.Acc.fs, 2));
                    title('Acc.Read.data')
                    
                
            end
        end
    end
end