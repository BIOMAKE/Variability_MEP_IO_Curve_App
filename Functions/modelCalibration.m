classdef modelCalibration < handle
    %% This class is for model calibration
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

    %% properties: dataset has been log-transformed and process dialog
    properties
        x_axis % this is x-axis data, has been log-transformed
        y_axis % this is y_axis data, has been log-transformed
        processDlg = [] % process dialog
    end

    %% properties: optimisation method
    properties
        optimisationMethodList = {'Particle-Swarm', 'Simplex', 'Interior-Point'} % store the optimisation method (string)
        selectedOptimisationMethodValue = 'Particle-Swarm' % selected optimisation method
        maximumIteration = 1000 % the maximum iteration for the selected method
        maximumFunctionValue = 7000 % the maximum number of function evaluation
        functionTolerance = 1e-6 % the minimum function evaluation tolerance
        stopTolerance = 1e-6 % stop tolerance
    end

    %% properties: models
    properties
        curveModelList = {'Hill Function (5DoF)'} % the model curve name
        selectedCurveModelValue = 'Hill Function (5DoF)' % name selected curve model
        selectedCurveModelClass % this is the selected model class
        iniPoints % initial points for algorithms
    end

    %% Variability selection
    properties
        vx_selected = true % indicator if we consider vx in curve model
    end

    %% properties: maximum-likelihood estimation optimisation results
    % 7 parameters including vx and vy in total
    properties
        opti_parameters_regression % standard least-square regression parameters
        opti_BIC_maximumlikelihood % Bayesian information criterion
        opti_parameters_maximumlikelihood % the optimal parameters for curve model using MLH method
        opti_fval_maximumlikelihood % objective function value at solution
        opti_exitflag_maximumlikelihood % reason why algorithm stops
        opti_output_maximumlikelihood % algorithm outputs
        opti_elapsed_time % algorithm elapsed time
    end

    %% basic methods
    methods
        %% this is the initial function
        function obj = modelCalibration()
            switch obj.selectedCurveModelValue
                case 'Hill Function (5DoF)'
                    obj.selectedCurveModelClass = Hill5PCurveModel();

                otherwise % load default model
                    obj.selectedCurveModelClass = Hill5PCurveModel();
            end
        end


        %% load the data
        function obj = loadData(obj, x_value, y_value)
            % initialise
            obj.x_axis = x_value;
            obj.y_axis = y_value;
        end


        %% attached a process dialog to this class
        function obj = attachDialog(obj, dialog)
            obj.processDlg = dialog;
        end
        

        %% check if the numeric property is empty
        function str = repEmptyProp(obj, property)
            if isempty(property)
                str = 'NaN';
            else
                str = num2str(property);
            end
        end


        %% summary the optimisation results
        function resultTable = summariseOptiTable(obj, finishedFlag)
            % This cell contains all model information
                cellTable = {'Curve Model:',                                obj.selectedCurveModelValue;
                             'Model Parameter:',                            obj.selectedCurveModelClass.modelParameterSet;
                             'Variability sources:',                        ['Vx: ', num2str(obj.vx_selected) '; ', 'Vy: ', '1.'];
                             ' ', ' ';
                             'Database information', ' ';
                             'Number of pairs (x, y):',                     obj.repEmptyProp(length(obj.x_axis));
                             'X-axis range:',                               ['[', obj.repEmptyProp(min(obj.x_axis)), ', ' obj.repEmptyProp(max(obj.x_axis)), ']'];
                             'Y-axis range',                                ['[', obj.repEmptyProp(min(obj.y_axis)), ', ' obj.repEmptyProp(max(obj.y_axis)), ']'];
                             ' ', ' ';
                             'Optimisation settings', ' ';
                             'Optimisation Method:',                        obj.selectedOptimisationMethodValue;
                             'Maximum iteration:',                          obj.repEmptyProp(obj.maximumIteration);
                             'Maximum function evaluation number:'          obj.repEmptyProp(obj.maximumFunctionValue);
                             'Function tolerance:',                         obj.repEmptyProp(obj.functionTolerance);
                             'Stop tolerance:',                             obj.repEmptyProp(obj.stopTolerance);
                             };
                if finishedFlag 
                    optimisedResults = {' ', ' ';
                                       'Optimisation results', ' ';
                                       'Optimimal maximum-likelihood parameters:',    ['[', strjoin(compose('%.3f', obj.opti_parameters_maximumlikelihood), ", "), ']'];
                                       'Objective function value at solution:',       obj.repEmptyProp(obj.opti_fval_maximumlikelihood);
                                       'Bayesian information criterion (BIC):',       obj.repEmptyProp(obj.opti_BIC_maximumlikelihood);
                                       'Exit flag:',                                  obj.repEmptyProp(obj.opti_exitflag_maximumlikelihood);
                                       'Algorithm iteration:',                        obj.repEmptyProp(obj.opti_output_maximumlikelihood.iterations);
                                       'Elapsed time:',                               [obj.repEmptyProp(obj.opti_elapsed_time), ' seconds'];
                                       'Algorithm output message:',                   obj.repEmptyProp(obj.opti_output_maximumlikelihood.message);};
                    cellTable = [cellTable; optimisedResults];
                end

            resultTable = cell2table(cellTable, "VariableNames", {'Name', 'Value'});
        end


        %% check all optimisation parameter settings
        function state = checkParameters(obj)
            % check if one of those parameters is zero
            value = obj.functionTolerance*obj.maximumFunctionValue*...
                obj.maximumIteration*obj.stopTolerance;
            if value == 0
                state = false;
            else
                state = true;
            end
        end


        %% print the curve models
        function txt = printCurveModel(obj)
            switch obj.selectedCurveModelValue
                case 'Hill Function (5DoF)'
                    txt = obj.selectedCurveModelClass.modelDescription;
                otherwise
                    txt = " ";
            end
        end


        %% Main: Run optimisation
        function obj = runCalibration(obj)
            % if processDlg is not loaded, use default value
            if isempty(obj.processDlg)
                obj.processDlg.CancelRequested = false;
            end
            
            % select an objective function
            switch obj.selectedCurveModelValue
                case 'Hill Function (5DoF)'
                    % parameters: [p1, p2, p3, p4, p5, vy, vx]
                    obj.selectedCurveModelClass.initialiseModel(obj.x_axis, obj.y_axis) % create a model function class
                    objFunction = @(parameters)...
                        obj.selectedCurveModelClass.likelihoodObjFunction(parameters, obj.vx_selected, obj.processDlg.CancelRequested);
                    
                    % get the initial points, last number is sigma_x for normal distribution.
                    obj.opti_parameters_regression = obj.selectedCurveModelClass.opti_parameters_regression;
                    obj.iniPoints = obj.selectedCurveModelClass.opti_iniPoints;

                    % get the optimisation bounds
                    bounds = obj.selectedCurveModelClass.opti_bounds;
                otherwise
                    % do nothing
            end


            % run optimisation
            % start time
            timeStart = tic;
            switch obj.selectedOptimisationMethodValue
                case 'Simplex' % using fminsearch
                    options = optimset('Display', 'iter', 'MaxIter', obj.maximumIteration,...
                        'MaxFunEvals', obj.maximumFunctionValue, 'TolFun', obj.functionTolerance, 'TolX', obj.stopTolerance);
                    [obj.opti_parameters_maximumlikelihood, obj.opti_fval_maximumlikelihood,...
                        obj.opti_exitflag_maximumlikelihood, obj.opti_output_maximumlikelihood] = ...
                        fminsearch(objFunction, obj.iniPoints, options);

                case {'Interior-Point'} % using fmincon
                    % set constriants
                    A = []; b = [];
                    Aeq = []; beq = [];
                    lb = bounds(1, :)'; % lower bound
                    ub = bounds(2, :)'; % upper bound
                    nonlcon = [];

                    % optimisation options
                    options = optimoptions('fmincon', 'Algorithm', obj.selectedOptimisationMethodValue, 'Display', 'iter', 'MaxIter', obj.maximumIteration,...
                        'MaxFunEvals', obj.maximumFunctionValue, 'TolFun', obj.functionTolerance, 'TolX', obj.stopTolerance);

                    % optimisation fmincon
                    [obj.opti_parameters_maximumlikelihood, obj.opti_fval_maximumlikelihood,...
                        obj.opti_exitflag_maximumlikelihood, obj.opti_output_maximumlikelihood] = ...
                        fmincon(objFunction, obj.iniPoints, A, b, Aeq, beq, lb, ub, nonlcon, options);

                case {'Particle-Swarm (Default)', 'Particle-Swarm'} % using particleswarm
                    % set the lower and upper bounds, 7 parameters
                    lb = bounds(1, :); % lower bound
                    ub = bounds(2, :); % upper bound
                    % number of parameters
                    nvar = length(lb);
                    % optimisation method
                    options = optimoptions('particleswarm', 'Display', 'iter', 'SwarmSize', 100, 'MaxIterations', obj.maximumIteration,...
                        'FunctionTolerance', obj.functionTolerance);
                    [obj.opti_parameters_maximumlikelihood, obj.opti_fval_maximumlikelihood,...
                        obj.opti_exitflag_maximumlikelihood, obj.opti_output_maximumlikelihood] = ...
                        particleswarm(objFunction, nvar, lb, ub, options);

                otherwise
                    % do nothing
            end
            % end time
            obj.opti_elapsed_time = toc(timeStart);

            % calculate BIC
            obj.opti_BIC_maximumlikelihood = 2*obj.opti_fval_maximumlikelihood + log(length(obj.x_axis))*length(obj.opti_parameters_maximumlikelihood);

            % output
            if not(obj.vx_selected)
                obj.opti_parameters_maximumlikelihood = obj.opti_parameters_maximumlikelihood(1:6);
            end

        end

    end


end