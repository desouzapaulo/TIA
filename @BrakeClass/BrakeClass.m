classdef BrakeClass < handle
    properties
    % Data type and folder
    folder = '';
    logger = '';
    Acc AccClass = AccClass.empty
    % Geometric parameters
    W double = double.empty; % car weight [kg]
    psi double = double.empty; % longitudinal weight distribution
    chi double = double.empty; % vertical weight distribution
    Fz double = double.empty; % dynamic reaction on wheels [N]
    mu double = double.empty; % friction coeffitient of the wheel/groud interface
    a_fr double = double.empty; % line of constant friction
    % Braking system parameters
    Amc double = double.empty; % master cylinder cross-section area [cm²]
    Awc double = double.empty; % wheel cylinder cross-section area [cm²]
    Rext double = double.empty; % brake rotor external radius [mm]
    Hp double = double.empty; % brake pad height [mm]
    l_p double = double.empty; % pedal lever ratio
    Pl double = double.empty; % Hydraulic pressure produced by pedal force
    r double = double.empty; % effective braking radius
    R double = double.empty; % wheel radius
    Po = 7; % push-out pressure [N/cm²]
    BF = 0.8; % brake factor
    nu_p = 0.8; 
    nu_c = 0.98; % wheel cylinder efficiency
    mu_p = 0.45; % brake pad friction coefficient
    % Braking Analysis
    Fx_optm double = double.empty; % optimal braking forces
    Fx_real double = double.empty; % real braking forces
    phi double = double.empty; % Real braking poportion (with the sistem dimentions)
    phi_var double = double.empty; % braking bias (the same as the BBB if both axes have the same system dimentions)
    % Braking adjustment
    Fpedal_var  = 10:10:2000; % force applied by the pilot [N]
    BBB double = double.empty; % brake bias adjustement
    g = 9.81; % gravity constant
    end
    %% constructor
    methods
        function obj = BrakeClass(folder, logger, psi, chi, BBB, parameters)
            obj.folder = folder;
            obj.logger = logger;
            obj.Acc = AccClass(obj.folder, obj.logger);

            obj.psi = psi;
            obj.chi = chi;

            obj.W = parameters(1, 2)*obj.g;            
            obj.l_p = parameters(2, 2);
            obj.Amc = parameters(3, 2:3);
            obj.Awc = parameters(4, 2:3);
            obj.Rext = parameters(5, 2:3);
            obj.Hp = parameters(6, 2:3);            
            obj.R = parameters(7, 2:3);

            obj.r = obj.Rext - (obj.Hp./2);

            obj.BBB = [(1-BBB) BBB];
            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OPTIMUM BRAKE LINE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function calcOptBrake(obj)
        %% dynamic reaction on Wheels        
            Fzf = (1 - obj.psi + obj.chi.*(obj.Acc.Read.data(:, 2))).*obj.W;
            Fzr = (obj.psi - obj.chi.*(obj.Acc.Read.data(:, 2))).*obj.W;
            obj.Fz = [Fzf Fzr];
       
        %% Braking forces
            Fxf = (1 - obj.psi + obj.chi.*(obj.Acc.Read.data(:, 2))).*((obj.Acc.Read.data(:, 2)).*obj.W);
            Fxr = (obj.psi - obj.chi.*(obj.Acc.Read.data(:, 2))).*((obj.Acc.Read.data(:, 2)).*obj.W);
            obj.Fx_optm = [Fxf Fxr];

        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%REAL BRAKING LINE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function calcRealBrake(obj)

            %% Hydraulic pressure produced by pedal force
            obj.Pl = zeros(size(obj.Fpedal_var, 2), 2);
            obj.Pl(:, 1) = obj.BBB(1)*2.*(((obj.Fpedal_var).*obj.l_p*obj.nu_p)./obj.Amc(1));
            obj.Pl(:, 2) = obj.BBB(2)*2.*(((obj.Fpedal_var).*obj.l_p*obj.nu_p)./obj.Amc(2));
            
    
            %% Actual braking force
            obj.Fx_real = zeros(size(obj.Fpedal_var, 2), 2);
            obj.Fx_real(:, 1) = 2.*(obj.Pl(:, 1) - obj.Po).*obj.Awc(1).*(obj.nu_c*obj.BF).*(obj.r(1)/obj.R(2));
            obj.Fx_real(:, 2) = 2.*(obj.Pl(:, 2) - obj.Po).*obj.Awc(2).*(obj.nu_c*obj.BF).*(obj.r(1)/obj.R(2));

            %% Braking distribution
            obj.phi_var = (obj.Fx_real(:, 2)./(obj.Fx_real(:, 2) + obj.Fx_real(:, 1)));
        end

        function calcCntFriction(obj)
            %% Lines of constant friction
            obj.a_fr = [(((1-obj.psi)*obj.mu(1))/(1-obj.chi*obj.mu(1))) ((obj.psi*obj.mu(2))/(1+obj.chi*obj.mu(2)))];
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PLOTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
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
            title('')s
            plot(obj.Acc.Read.acqrt)
            xlabel('Acquisition Rate')
            ylabel('Samples')
            grid on
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%STATISTICS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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