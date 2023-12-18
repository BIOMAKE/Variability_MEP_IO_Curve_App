classdef Hill5PCurveModel < handle
    %%
    % This is a hill function with 7 parameters:
    % parameters(1) - p1; parameters(2) - p2; parameters(3) - p3;
    % parameters(4) - p4; parameters(5) - p5; 
    % parameters(6) - sigma_y; parameters(7) - sigma_x;
    % p1 + (p2-p1)/(1 + p3/((x-p5)^p4;
    % p6:     y standard deviation / y normalization (Normal distribution)
    % p7:     x standard deviation / x normalization (Normal distribution)
    % xivec:  x values
    % yivec:  y values, corresponding to xivec (pair-wise) -- or one
    %         xivec value and n yivec values
    %
    % Author: Ke Ma, Stephan M. Goetz; @10/12/2023
    % MATLAB version: R2022b
    %
    % This code is available for private and academic use, provided that any 
    % resulting publications, presentations, or academic works citing
    % the use of the Software include an appropriate citation
    % acknowledging the Software and its authors.
    %
    % Users must contact us to obtain a separate agreement before using
    % the Software for commercial purposes. Commercial use includes, 
    % but is not limited to, incorporating the Software into a product 
    % for sale or distribution, or using the Software to provide services
    % or support for a commercial entity.
    %
    % Email: km834@cam.ac.uk, smg84@cam.ac.uk

    %%
    % properties: dataset: has been log-transformed
    properties
        x_axis      % x_axis value
        y_axis      % y_axis value
        x_unique    % arranged data
        y_arrange   % arranged data
    end

    %%
    % find the initial points for later maximum-likelihood estimation (MLE) optimisation
    % properties: nonlinear regression optimisation
    % 5 parameters in total
    properties
        opti_parameters_regression  % the optimial parameters for curve model using normal regression method
        opti_fval_regression        % objective function value at solution
        opti_exitflag_regression    % reason why algorithm stops
        opti_output_regression      % algorithm outputs
    end

    %% optimisation range
    properties
        opti_bounds     % optimisation upper and lower bounds
        opti_iniPoints  % initial points for optimisation
    end

    %% Model text
    properties
        modelName = 'Hill Function (5DoF)' % model name
        modelDescription = ["f(x) = p1 + (p2-p1)/(1 + p3/((x-p5)^p4)";
                        "p1 - the minimum function value";
                        "p2 - the maximum function value";
                        "p3 - the scale factor for x";
                        "p4 - the exponent";
                        "p5 - the shift value for x"]  % model description
        modelParameterSet = "[p1, p2, p3, p4, p5, Vy, Vx]" % model parameter string
    end


    %% Methods
    methods
        %% initialise the class and find the initial opti points for later MLE
        function obj = Hill5PCurveModel()
        end


        %% initialise the class and find the initial opti points for later MLE
        function initialiseModel(obj, xivec, yivec)
            % save dataset
            obj.x_axis = xivec;
            obj.y_axis = yivec;

            % Re-arrange the input data into cell array
            % Group yivec by xivec
            obj.x_unique = unique(xivec);
            obj.y_arrange = cell(1, length(obj.x_unique));
            for icnt = 1:length(obj.x_unique)
                obj.y_arrange{icnt} = yivec(xivec == obj.x_unique(icnt));
            end

            % Run linear regression for the model
            obj.runLinearRegression()
        end


        %% Run the normal regression for the model
        function runLinearRegression(obj)
            % inputs
            xivec = obj.x_axis;
            yivec = obj.y_axis;

            % objective function
            objFunction_regression = @(parameters) sum((Hill5PCurveModel.modelCurveFunction(parameters, xivec) - yivec).^2);

            % number of parameters
            nvar = 5;
            % set the lower and upper bounds, 5 parameters
            p1 = [min(obj.y_axis) - 1e-5; max(obj.y_axis) + 1e-5]; p2 = [min(obj.y_axis) - 1e-5; max(obj.y_axis) + 1e-5];
            p3 = [1e-5; 200]; p4 = [1e-5; 10]; p5 = [1e-5; 100];
            bounds = [p1, p2, p3, p4, p5];
            lb = bounds(1, :); % lower bound
            ub = bounds(2, :); % upper bound
            % optimisation method: particle swarm algorithm
            options = optimoptions('particleswarm', 'SwarmSize', 150);
            [obj.opti_parameters_regression, obj.opti_fval_regression, obj.opti_exitflag_regression, obj.opti_output_regression] = ...
                particleswarm(objFunction_regression, nvar, lb, ub, options);

            % estimate the vy variability
            residuals = Hill5PCurveModel.modelCurveFunction(obj.opti_parameters_regression, xivec) - yivec;
            sigma_y_est = std(residuals);

            % update new parameters with residual distribution (vy)
            obj.opti_parameters_regression = [obj.opti_parameters_regression, sigma_y_est];
            obj.opti_iniPoints = [obj.opti_parameters_regression, exp(2)];

            % update optimisation bounds
            p6 = [1e-5; sigma_y_est + 1]; p7 = [1e-5; 10];
            obj.opti_bounds = [bounds, p6, p7];
        end


        %% Likelihood objective function
        function loglikelihoodValue = likelihoodObjFunction(obj, parameters, vx_selected, stopFlag)
            % Input pairs:
            % obj.x_unique and obj.y_arrange
            %
            % Variability sources:
            % vx - additive noise at the input side
            % vy - multiplicative noise at the output side (default noise source)
            %
            % Options:
            % stopFlag - stop optimisation during running
            % vx_selected - select/consider/include vx or not

            %% if stop optimisation during running
            if stopFlag
                error('Stop Optimisation.')
            end

            %% Calculate the negative log-likelihood
            xivec = obj.x_unique; yivec = obj.y_arrange;

            likelihoodValue = 0;
            for icnt = 1:length(xivec)
                % calculate the probability distribution for a given x
                [full_distribution, Youtput_corresp] = ...
                    Hill5PCurveModel.calculateLikelihoodDistribution(parameters, xivec(icnt), vx_selected);
                % find the corresponding likelihood for y
                y_likelihood = interp1(Youtput_corresp, full_distribution, yivec{icnt}, 'linear');
                y_likelihood(y_likelihood == 0) = eps; % to avoid log MLE to be infinit
                y_likelihood(isnan(y_likelihood)) = eps;
                %
                likelihoodValue = likelihoodValue + sum(log(y_likelihood));
            end

            % negative log-likelihood value
            loglikelihoodValue = - likelihoodValue;            
        end


    end

    %% static method
    methods(Static)
        %% Hill function
        function FunValue = modelCurveFunction(parameters, xivec)
            % 1000*eps here is to make sure the denominator will not be
            % zero (interesting!?).
            FunValue = parameters(1) + (parameters(2)-parameters(1))./( 1 + parameters(3)./(1000*eps + (xivec-parameters(5)).*((xivec-parameters(5))>0)).^parameters(4) );
        end


        %% Inverse Hill function
        function FunValue = inverseModelCurveFunction(parameters, yivec)
            % For the inverse function, the lower limit of y should be larger than
            % parameters(1), that is, y > p1. Therefore, for y < p1, we let y = p1 by
            % using Heaviside function.
            FunValue = (( parameters(3)*(yivec-parameters(1))./(parameters(2)-yivec) ).^(1/parameters(4)) + parameters(5)) .*(yivec>=parameters(1)) + parameters(1).*(yivec<parameters(1));
        end


        %% Hill function: calculate a single y likelihood according to a given x
        function [full_distribution, Youtput_corresp] = calculateLikelihoodDistribution(parameters, xivec, vx_selected)
            %% This function aims to calculate the probability of y given x considering two/one variability sources, either vx or vy.
            % This probability could be used to construct the likelihood
            % function for a given xivec.
            % The whole system follows:
            % x_tilde = xivec + vx, y_tilde = S(x_tilde),
            % yivec = y_tilde + vy, yivec = log10(MEP). 

            %% Hill function and its inverse function
            % Hill function
            myfunction = @(myx) Hill5PCurveModel.modelCurveFunction(parameters, myx);
            % Inverse Hill function
            myinversefunction = @(myy) Hill5PCurveModel.inverseModelCurveFunction(parameters, myy);

            %% y-axis range and its variability distribution
            % define the highest and lowest y value
            lowestlevel_y = min(parameters(1), parameters(2));
            highestlevel_y = max(parameters(1), parameters(2));

            % the distribution parameter of vy
            sigma_y = parameters(6);
                    
            % First, define the valid range of y: numerically evaluate the density distribution
            % The lowest value of y is "parameters(1) - 5.5*sigma_y";
            % The highest value of y is "parameters(2) + 5.5*sigma_y";
            numSamples = 1000;
            Yrange = linspace(lowestlevel_y - 6*sigma_y, highestlevel_y + 6*sigma_y, numSamples);
            Yrange_diff = mean(diff(Yrange));

            switch vx_selected
                case true
                    % the distribution parameter of vx
                    sigma_x = parameters(7);
                    % numerically evaluate vy distribution density
                    % the mean value is Yrange(end/2) - the middle index "end/2"
                    PDF_vy = normpdf(Yrange - Yrange(end/2), 0, sigma_y);

                    % calculate the corresponding x range according to y range
                    x_tilde = real(myinversefunction(Yrange));
                    x_tilde(Yrange < lowestlevel_y) = xivec - 100*sigma_x; % if y-value is too low, the corresponding x-value must be very small.
                    x_tilde(Yrange > highestlevel_y) = xivec + 100*sigma_x; % if y-value is too high (saturated), the corresponding x-value must be very high.
                   
                    % calculate the cumulative distribution value for vx
                    % and its transformed PDF after S(*) model
                    CDF_vx = normcdf(x_tilde - xivec, 0, sigma_x);
                    CDF_vx_diff_transformed = [0, diff(CDF_vx)] / Yrange_diff;
                    % correct the transformed PDF
                    CDF_vx_diff_transformed_correct = CDF_vx_diff_transformed / sum(Yrange_diff * CDF_vx_diff_transformed);

                    % Calculate the y probability density distribution.
                    % Note that only for equal sampling!
                    full_distribution = Yrange_diff * conv(PDF_vy, CDF_vx_diff_transformed_correct, 'full');
                    Youtput_corresp = min(Yrange) + min(Yrange - Yrange(end/2)) : Yrange_diff : max(Yrange) + max(Yrange - Yrange(end/2));
                    Youtput_corresp = [Youtput_corresp, zeros(1, 2*numSamples - 1 - length(Youtput_corresp))];

                
                case false
                    full_distribution = normpdf(Yrange - Yrange(end/2), 0, sigma_y);
                    Youtput_corresp = Yrange - Yrange(end/2) + myfunction(xivec);
            end
        end


        %% calculate quantiles for error band
        function Yquantile = calculateQuantile(parameters, xivec, vx_selected)
            % Input argument:
            % parameters - model parameters;
            % xmax - define the maximum value of the x range;
            % vx_selected - if the variability of vx is selected
            %
            % Output:
            % Yquantile - a table summarises the calculated quantile of y

            % calculate quantiles for error band
            quantile_vec = [0.05/2, 0.15/2, (1-0.15/2), (1-0.05/2)]; % 0.95 and 0.85 variability range
            xvec = linspace(0.95*(min(xivec)), 1.05*max(xivec), 1000); % provide a x-range
            quantile_y = zeros(length(xvec), length(quantile_vec)); % create an array

            % calculate y distribution at each x point
            for i = 1:length(xvec)
                % calculate the cumulative probability for y
                [YprobDistribution, Youtput_corresp]  = Hill5PCurveModel.calculateLikelihoodDistribution(parameters, xvec(i), vx_selected);
                YcumDistribution = cumsum([0, diff(Youtput_corresp)] .* YprobDistribution);

                % find corresponding y closest to Yquantile
                quantile_y(i, :) = interp1(YcumDistribution(YprobDistribution>1e-12), Youtput_corresp(YprobDistribution>1e-12), quantile_vec, 'linear');
            end

            % arrange table
            Yquantile = array2table([xvec', quantile_y], 'VariableNames', {'x', '0.025', '0.075', '0.925', '0.975'});
        end


        %% calculate the excitation level and the corresponding p-value from a stimulus-reponse pair
        % Goetz SM, Howell B, Wang B, Li Z, Sommer MA, Peterchev AV, Grill WM. 
        % Isolating two sources of variability of subcortical stimulation to quantify
        % fluctuations of corticospinal tract excitability. Clinical Neurophysiology. 2022 Jun 1;138:134-42.
        function [excitationLevel, pvalue, yresidual] = getExcitation(stimulusAmplitude, Vpp, parameters)
            % Vpp should be log-transformed
            % get parameters
            sigma_x = parameters(7);
            sigma_y = parameters(6);

            % define the intersection function
            intFunction = @(x) abs(Hill5PCurveModel.modelCurveFunction(parameters, x) - ...
                (Vpp - sigma_y/sigma_x*(x - stimulusAmplitude)));

            % find the intersection point
            crossingx = fminsearch(intFunction, parameters(5));

            % evaluate the excitation level
            excitationLevel = crossingx - stimulusAmplitude;

            % p-value: one-tailed p-value test
            pvalue = normcdf(-1*abs(Vpp - Hill5PCurveModel.modelCurveFunction(parameters, stimulusAmplitude)),...
                0, sigma_y);

            % residual
            yresidual = Vpp - Hill5PCurveModel.modelCurveFunction(parameters, stimulusAmplitude);
        end


    end


end