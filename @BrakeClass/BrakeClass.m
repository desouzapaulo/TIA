classdef BrakeClass < handle
    properties
    % Data type and folder
    folder = '';
    logger = '';
    Acc AccClass = AccClass.empty;
    a double = double.empty;
    % Geometric parameters
    W double = double.empty; % car weight [kg]
    psi double = double.empty; % longitudinal weight distribution
    chi double = double.empty; % vertical weight distribution
    Fz double = double.empty; % dynamic reaction on wheels [N]
    mu_T double = double.empty; % friction coeffitient of the wheel/groud interface at a fixed acceleration
    mu_real double = double.empty; % friction coeffitient of the wheel/groud interface
    mu_optm double = double.empty; % friction coeffitient of the wheel/groud interface
    a_fr double = double.empty; % line of constant friction
    % Braking system parameters
    Amc double = double.empty; % master cylinder cross-section area [cm²]
    Awc double = double.empty; % wheel cylinder cross-section area [cm²]
    Rext double = double.empty; % brake rotor external radius [mm]
    Hp double = double.empty; % brake pad height [mm]
    l_p double = double.empty; % pedal lever ratio
    Pl double = double.empty; % Hydraulic pressure produced by pedal force
    Pl_optm double = double.empty; % optimal hydraulic pressure
    Pl_Pedal double = double.empty; % hydraulic pressure for certain pedal force
    r double = double.empty; % effective braking radius
    R double = double.empty; % wheel radius
    % Parametros tabelados que podem ser medidos por experimentos e corrigidos
    Po = [7 7]; % push-out pressure [N/cm²]
    BF = 0.8; % brake factor
    nu_p = 0.8; % brake pedal efficiency
    nu_c = 0.98; % wheel cylinder efficiency
    mu_p = 0.45; % brake pad friction coefficient
    % Braking Analysis
    Fx_optm double = double.empty; % optimal braking forces
    Fx_real double = double.empty; % real braking forces
    phi double = double.empty; % Real braking poportion (with the sistem dimentions)
    phi_var double = double.empty; % braking bias (the same as the BBB if both axes have the same system dimentions)
    E double = double.empty; % Braking efficiency
    % Braking adjustment
    Fpedal double = double.empty; % Fixed pedal force for brake distribution [N]  
    Fpedal_var double = double.empty; 
    BBB double = double.empty; % brake bias adjustement
    g = 9.81; % gravity constant
    end
    %% constructor
    methods
        function obj = BrakeClass(folder, logger)
            obj.folder = folder;
            obj.logger = logger;
            obj.Acc = AccClass(obj.folder, obj.logger);                                       
        end

        function ReadParameters(obj, psi, chi, BBB, parameters)
            if obj.logger == "PHONE"
                obj.Acc.Read.fft
                obj.Acc.Read.filter(2)
            end
            obj.a = abs(obj.Acc.Read.data(:, 2)./obj.g);

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
        function solveOptBrake(obj)
            % dynamic reaction on Wheels        
            Fzf = (1 - obj.psi + obj.chi.*(obj.a)).*obj.W; % (Limpert eq 7.3a)
            Fzr = (obj.psi - obj.chi.*(obj.a)).*obj.W; % (Limpert eq 7.3b)
            obj.Fz = [Fzf Fzr];
            
            % Braking forces
            Fxf = (1 - obj.psi + obj.chi.*(obj.a)).*((obj.a).*obj.W); % (Limpert eq 7.5a)
            Fxr = (obj.psi - obj.chi.*(obj.a)).*((obj.a).*obj.W); % (Limpert eq 7.5b)
            obj.Fx_optm = [Fxf Fxr];

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%REAL BRAKING LINE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function solveRealBrake(obj)
            obj.Fpedal_var  = linspace(0, 2000, size(obj.a, 1)); % force applied by the pilot [N]

            %% Hydraulic pressure produced by pedal force (Limpert eq 5.1)
            obj.Pl = zeros(size(obj.Fpedal_var, 2), 2); % [N/cm²]
            obj.Pl(:, 1) = obj.BBB(1)*(((obj.Fpedal_var).*obj.l_p*obj.nu_p)./(obj.Amc(1))); 
            obj.Pl(:, 2) = obj.BBB(2)*(((obj.Fpedal_var).*obj.l_p*obj.nu_p)./(obj.Amc(2)));

            %% Optimum hydraulic pressure
            obj.Pl_optm = zeros(length(obj.a), 2);
            obj.Pl_optm(:, 1) = ((1-obj.psi+obj.chi.*obj.a).*obj.W*obj.R(1).*obj.a) ./ (2*(obj.Awc(1)*obj.BF*obj.r(1)*obj.nu_c))+obj.Po(1); % (Limpert eq 7.30a)
            obj.Pl_optm(:, 2) = ((obj.psi-obj.chi.*obj.a).*obj.W*obj.R(1).*obj.a) ./ (2*(obj.Awc(2)*obj.BF*obj.r(2)*obj.nu_c))+obj.Po(2); % (Limpert eq 7.30b)
    
            %% Actual braking force (Limpert eq 5.2)
            obj.Fx_real = zeros(size(obj.Fpedal_var, 2), 2); % [N]
            obj.Fx_real(:, 1) = 2.*(obj.Pl(:, 1) - obj.Po(1)).*obj.Awc(1).*(obj.nu_c*obj.BF).*(obj.r(1)/obj.R(2)); 
            obj.Fx_real(:, 2) = 2.*(obj.Pl(:, 2) - obj.Po(2)).*obj.Awc(2).*(obj.nu_c*obj.BF).*(obj.r(1)/obj.R(2));
                      
            %% Braking distribution (Limpert eq 7.15)
            obj.phi_var = (obj.Fx_real(:, 2)./(obj.Fx_real(:, 2) + obj.Fx_real(:, 1)));
        end

        function solveFpedal(obj, a)
            tol = 0.01;
            for i = 1:size(obj.Fx_real, 1)
                totalacc = (obj.Fx_real(i, 1) + obj.Fx_real(i, 1))/obj.W;
                if  totalacc <= a + tol
                    if totalacc >= a - tol
                        obj.phi = (obj.Fx_real(i, 2)/(obj.Fx_real(i, 2) + obj.Fx_real(i, 1)));
                        obj.Fpedal = obj.Fpedal_var(i)/obj.g; % [kg]
                        obj.Pl_Pedal = [obj.Pl(i, 1)*0.1 obj.Pl(i, 2)*0.1]; % [Bar]
                    end
                end
            end
            if obj.Fpedal >= 100
                warning('Pedal force is above 100 kg')
            elseif obj.Fpedal <= 10
                warning('Pedal force is below 10 kg')
            end            
        end

        function solvemu(obj, a)
            %% (Limpert eq 7.17a) (Limpert eq 7.17b) % revisar, acho que esta ao contrario
            obj.mu_T = [(((1-obj.phi)*a)/(1-obj.phi+obj.chi*a)) ((obj.phi*a)/(obj.phi-obj.chi*a))];
        end

        function solvemu_real(obj)
            obj.mu_real = [obj.Fx_real(:, 1)./obj.Fz(:, 1) obj.Fx_real(:, 2)./obj.Fz(:, 2)];            
        end

        function solvemu_optm(obj)
            obj.mu_optm = [obj.Fx_optm(:, 1)./obj.Fz(:, 1) obj.Fx_optm(:, 2)./obj.Fz(:, 2)];            
        end

        function solveCntFriction(obj)
            %% Lines of constant friction (Limpert eq 7.11a) (Limpert eq 7.11b)
            obj.a_fr = [(((1-obj.psi)*obj.mu_T(1))/(1-obj.chi*obj.mu_T(1))) ((obj.psi*obj.mu_T(2))/(1+obj.chi*obj.mu_T(2)))];
        end

        function solveBrakeEff(obj)
            %% (Limpert eq 7.18a) (Limpert eq 7.18b)
            obj.E = [((1-obj.psi)/(1-obj.phi-obj.mu_T(1)*obj.chi)) (obj.psi/(obj.phi+obj.mu_T(2)*obj.chi))];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%PLOTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function pltAcc(obj)
            hold(fig, 'off')
            title(fig, 'Acc')
            plot(fig, obj.Acc.Read.t, obj.a)
            xlabel(fig, 'time [s]')
            ylabel(fig, 'Acceleration [g]')
        end
         
        function pltfft(obj, fig)
            hold(fig, 'off')
            title(fig, 'FFT')
            plot(fig, obj.Acc.Read.w, obj.Acc.Read.A(:, 2))
            xlabel(fig, 'Amplitude')
            ylabel(fig, 'Frequency')
        end

        function pltacqrt(obj, fig)
            hold(fig, 'off')
            title(fig, '')
            plot(fig, obj.Acc.Read.acqrt)
            xlabel(fig, 'Acquisition Rate')
            ylabel(fig, 'Samples')
        end

        function pltbrkline(obj, fig)

            hold(fig, 'off')

            plotlimit = 1;  

            % --------------- Lines of constant -----------------                    
        
            for i = 1:length(obj.Fx_optm)
                if (obj.Fx_optm(i,1)/obj.W)+(obj.Fx_optm(i,2)/obj.W) == plotlimit
                    break
                end
            end

            x1 = obj.Fx_optm(1:i,2)./obj.W;
            y1 = obj.Fx_optm(1:i,1)./obj.W;
            x2 = linspace(0, obj.mu_T(1), length(obj.Fx_optm(1:i,2)));
            y2 = linspace(obj.mu_T(1), 0, length(obj.Fx_optm(1:i,2)));

            % intesection of lines
            [xi, yi] = polyxpoly(x1, y1, x2, y2, 'unique');

            axis(fig, [0 1 0 1]) % define axis limits

            % ---------------------------------------------------

            for j = 0.1:0.1:1               
                plot(fig, [0 j], [j 0], 'g--')
                hold(fig, "on")
            end       

            plot(fig, x1, y1) % optimum braking line
            plot(fig, [0 xi], [obj.a_fr(1) yi], 'r-') % line of disconnected front axel
            plot(fig, [obj.a_fr(2) xi], [0 yi], 'r-') % line of disconnected rear axel                    

            for j = 1:length(obj.Fx_optm)
                if (obj.Fx_real(j,1)/obj.W)+(obj.Fx_real(j,2)/obj.W) == plotlimit
                    break
                end
            end

            plot(fig, obj.Fx_real(1:j,2)./obj.W, obj.Fx_real(1:j,1)./obj.W)
            xlabel(fig, 'Dynamic Rear Axle Brake Force (Normalized)')
            ylabel(fig, 'Dynamic Front Axle Brake Force (Normalized)')
            title(fig, 'Brake line')
            hold(fig, "off")
        end

        function pltpress(obj, fig)

            hold(fig, 'off')

            x = obj.Fpedal_var./obj.g;
            y = obj.Pl(:, 1).*0.1 + obj.Pl(:, 2).*0.1;
            axis(fig, [0 x(end) 0 y(end)])
            title(fig, 'Hydraulic Pressure')
            
            ylabel(fig, 'Hydraulic Pressure [Bar]')                    
            xlabel(fig, 'Pedal Force [Kg]')                                     

            y = obj.Pl(:, 1).*0.1;
            plot(fig, x, y, 'DisplayName', 'Front Pressure')
            hold(fig, 'on')

            y = obj.Pl(:, 2).*0.1;
            plot(fig, x, y, 'DisplayName', 'Rear Pressure')
            
            legend(fig)
            hold(fig, 'off')
        end

        function pltbrkforce(obj, fig)
            hold(fig, 'off')

            x = obj.Fpedal_var./obj.g;
            y = obj.Fx_real(:, 1)./obj.W + obj.Fx_real(:, 2)./obj.W;
            axis(fig, [0 x(end) 0 y(end)])
            title(fig, 'Braking Forces')
            
            ylabel(fig, 'Braking Force (Normalized)')                    
            xlabel(fig, 'Pedal Force [Kg]')
            
            plot(fig, x, y, 'DisplayName', 'Total Braking force (Normalized)') 
            hold(fig, 'on')

            y = obj.Fx_real(:, 1)./obj.W;
            plot(fig, x, y, 'DisplayName', 'Front Braking force (Normalized)')

            y = obj.Fx_real(:, 2)./obj.W;
            plot(fig, x, y, 'DisplayName', 'Rear Braking force (Normalized)')
            
            legend(fig)
            hold(fig, 'off')    
        end

        function pltavgacc(obj, a, b, fig)
            hold(fig, 'off')
            histogram(fig, obj.Acc.Read.data(a*obj.Acc.Read.fs:b*obj.Acc.Read.fs, 2), 'Normalization', 'probability');            
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
                    histfit(obj.Acc.Read.data(a*obj.Acc.Read.fs:b*obj.Acc.Read.fs, 2),50,'Normal');
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