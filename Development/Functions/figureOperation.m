classdef figureOperation < handle
    %% this class is for ploting figures
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
    % properties: chinese color scheme
    properties
        cblack = [021, 029, 041]/255 % chinese black
        cred = [209, 041, 032]/255 % chinese red
        cblue = [018, 080, 123]/255 % chinese blue
        cyellow = [250, 192, 061]/255 % chinese yellow
        cgreen = [093, 163, 157]/255 % chinese green
        cpink = [237, 109, 070]/255 % chinese pink
    end

    % properties: dataset has been log-transformed
    properties
        x_axis
        y_axis
    end


    %%
    % methods
    methods
        %% initialise the class
        function obj = figureOperation
        end

        %% load data
        function obj = loadData(obj, xivec, yivec)
            obj.x_axis = xivec;
            obj.y_axis = yivec;
        end

        %% initialise all figures' legend and titles
        function initialiseFigures(obj, figHandle1, figHandle2, figHandle3)
            % variability MEP IO curve
            set(figHandle1, 'TickLabelInterpreter', 'latex');
            ylabel(figHandle1, 'MEP (mV)', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex')
            xlabel(figHandle1, 'Normalised Stimulus Strength', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex')
            title(figHandle1, 'Logarithmic Maximum-likelihood Model', 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex') 

            % excitation level
            set(figHandle2, 'TickLabelInterpreter', 'latex');
            ylabel(figHandle2, 'Excitation Level', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex')
            xlabel(figHandle2, 'Stimulus Number', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex')
            title(figHandle2, 'Excitation Level', 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex')

            % excitation p-value
            set(figHandle3, 'TickLabelInterpreter', 'latex');
            ylabel(figHandle3, 'p-value', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex')
            xlabel(figHandle3, 'Stimulus Number', 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex')
            title(figHandle3, 'Excitability p-value', 'FontSize', 16, 'FontWeight', 'bold', 'Interpreter', 'latex')

            % set grid for all axes
            cellfun(@(axes) set(axes, 'XGrid', 'on', 'YGrid', 'on', 'XMinorGrid', 'on', 'YMinorGrid', 'on', 'Box', 'on'), {figHandle1, figHandle2, figHandle3});
        end

        %% plot logarithmic MEP IO curve
        function plotSingleMEPIOCurve(obj, figHandle, parameters, selectedCurveModelValue)
            % clear aces
            cla(figHandle)

            % make hold on
            hold(figHandle, "on")

            % scatter plot for MEP measurement
            scatter(figHandle, obj.x_axis, 10.^obj.y_axis, 40, obj.cblack, 'Marker', 'x', 'LineWidth', 0.6)
            
            % plot for curve model
            x_model = linspace(0.95*min(obj.x_axis), 1.05*max(obj.x_axis), 1000); % define model x range
            y_model = figureOperation.calculateCurveModel(parameters, x_model, selectedCurveModelValue);
            plot(figHandle, x_model, 10.^y_model, 'LineStyle', '-', 'LineWidth', 1, 'Color', obj.cred)

            % labels
            legend(figHandle, 'Measurements', 'Model Curve', 'interpreter', 'latex', 'Location', 'Northwest')

            %
            set(figHandle, 'YScale', 'log')
            axis(figHandle, 'padded')

            % turn off hold
            hold(figHandle, "off")
        end


        %% plot logarithmic MEP IO curve with variability
        function plotMEPIOCurveVariability(obj, figHandle, parameters, selectedCurveModelValue, vx_selected)
            % clear axes
            cla(figHandle)

            % make hold on
            hold(figHandle, "on")

            % scatter plot for MEP measurement
            scatter(figHandle, obj.x_axis, 10.^obj.y_axis, 40, obj.cblack, 'Marker', 'x', 'LineWidth', 0.6)

            % plot for curve model
            x_model = linspace(0.95*min(obj.x_axis), 1.05*max(obj.x_axis), 1000); % define model x range
            y_model = figureOperation.calculateCurveModel(parameters, x_model, selectedCurveModelValue);
            plot(figHandle, x_model, 10.^y_model, 'LineStyle', '-', 'LineWidth', 1, 'Color', obj.cred)

            % plot Y quantile: 0.85 and 0.95 error range
            Yquantile = figureOperation.calculateYquantile(parameters, selectedCurveModelValue, obj.x_axis, vx_selected);
            plot(figHandle, Yquantile.x, 10.^Yquantile.("0.025"), 'LineStyle', '--', 'LineWidth', 1, 'Color', obj.cblue);
            plot(figHandle, Yquantile.x, 10.^Yquantile.("0.075"), 'LineStyle', '--', 'LineWidth', 1, 'Color', obj.cpink);
            plot(figHandle, Yquantile.x, 10.^Yquantile.("0.925"), 'LineStyle', '--', 'LineWidth', 1, 'Color', obj.cpink);
            plot(figHandle, Yquantile.x, 10.^Yquantile.("0.975"), 'LineStyle', '--', 'LineWidth', 1, 'Color', obj.cblue);

            % legend and label
            legend(figHandle, 'Measurements', 'Model Curve', '$0.95$ Variability Range', '$0.85$ Variability Range',...
                'interpreter', 'latex', 'Location', 'northwest')

            %
            axis(figHandle, 'padded')
            set(figHandle, 'YScale', 'log')

            %
            hold(figHandle, "off")
        end

        %% plot excitability level and corresponding p-value for each stimulus
        function plotExcitabilityLevel(obj, figHandle_exci, figHandle_pvalue, parameters, selectedCurveModelValue)
            % clear axes
            cla(figHandle_exci); cla(figHandle_pvalue);

            % make hold on
            hold(figHandle_exci, "on"); hold(figHandle_pvalue, 'on');

            % calculate excitability level and p-value
            [excitationLevel, pvalue, ~] = arrayfun(@(xivec, yivec)...
                figureOperation.calculateExcitability(parameters, selectedCurveModelValue, xivec, yivec), obj.x_axis, obj.y_axis);
            
            % x index
            xidx = 1:length(obj.x_axis);
            
            % figHandle_exci: plot excitability level
            plot(figHandle_exci, xidx, excitationLevel, 'LineWidth', 1, 'LineStyle', '-', 'Marker', 'square', 'MarkerSize', 10, 'Color', obj.cblack);
            scatter(figHandle_exci, xidx(pvalue < 0.05), excitationLevel(pvalue < 0.05), 40, obj.cred, "filled", 'Marker', 'square');
            yline(figHandle_exci, 0, 'LineWidth', 1, 'LineStyle', '--', 'Color', obj.cblack);
            %
            legend(figHandle_exci, 'Individual excitability value', 'Significant samples', 'Location', 'northwest', 'interpreter', 'latex');
            axis(figHandle_exci, 'padded')

            % figHandle_pvalue: plot p-value
            yline(figHandle_pvalue, 0.05, 'LineWidth', 2, 'LineStyle', '--', 'Color', obj.cred);
            b = bar(figHandle_pvalue, pvalue); set(b, 'FaceColor', obj.cblue, 'EdgeColor', obj.cblue);
            %
            legend(figHandle_pvalue, '$0.05$ significant level', 'Type-I error estimates', 'Location', 'northwest', 'interpreter', 'latex');
            axis(figHandle_pvalue, 'padded')

            % make hold on
            hold(figHandle_exci, "off"); hold(figHandle_pvalue, 'off');
        end

    end


    %% static methods
    methods(Static)
        %% for different selected curve model
        function yaxis = calculateCurveModel(parameters, x_model, selectedCurveModelValue)
            % switch condition depends on model curve
            switch selectedCurveModelValue
                case 'Hill Function (5DoF)'
                    yaxis = Hill5PCurveModel.modelCurveFunction(parameters, x_model);
                otherwise
                    % do nothing
            end
        end

        %% for different selected curve model: variability
        function Yquantile = calculateYquantile(parameters, selectedCurveModelValue, xivec, vx_selected)
            % switch condition
            switch selectedCurveModelValue
                case 'Hill Function (5DoF)'
                    Yquantile = Hill5PCurveModel.calculateQuantile(parameters, xivec, vx_selected);
                otherwise
                    % do nothing
            end
        end

        %% for different model: excitability level and p-value
        function [excitationLevel, pvalue, yresidual] = calculateExcitability(parameters, selectedCurveModelValue, stimulusAmplitude, Vpp)
            % switch condition
            switch selectedCurveModelValue
                case 'Hill Function (5DoF)'
                    [excitationLevel, pvalue, yresidual] = Hill5PCurveModel.getExcitation(stimulusAmplitude, Vpp, parameters);
                otherwise
                    % do nothing
            end


        end

    end

end