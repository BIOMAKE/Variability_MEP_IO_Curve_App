classdef tableOperation < handle
    %% tableOperation Summary of this class goes here
    % This class has several functions of handling tables.
    
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
    properties
        origTableFile % this is the objective table file
        normalisedTableFile % this is normalised table file
        logTransformedTableFile % this is log-transformed table file
        variableNames % variable name
    end

    methods
        %% this is the startup function
        function obj = tableOperation()
        end

        %% load table file
        function obj = loadData(obj, tablePath)
            obj.origTableFile = readtable(tablePath);
            obj.variableNames = obj.origTableFile.Properties.VariableNames;
        end

        %% normalise the values along the selected column
        function normalisedTable = normaliseAxis(obj, table, variableName, maxValue)
            selectedColumn = table.(variableName);
            table.(variableName) = maxValue * round(selectedColumn/max(selectedColumn), 3);
            obj.normalisedTableFile = table;
            normalisedTable = table;
        end

        %% log transform the values along the selected coloum
        function logTransformedTable = logTransformedAxis(obj, table, variableName)
            selectedColumn = table.(variableName);
            table.(variableName) = log10(selectedColumn); % log-transformed based on 10
            obj.logTransformedTableFile = table;
            logTransformedTable = table;
        end

    end

    %% static methods for parameter table
    methods(Static)
        % show the table in uitable
        function updateUItable(objUITable, optiSummaryTable, selectedCurveModel)
            %
            switch selectedCurveModel
                case 'Hill Function (5DoF)'
                    % parameters: [p1, p2, p3, p4, p5, vy, vx]
                    objUITable.Data = optiSummaryTable;
                otherwise
                    % do noting
            end
        end
    end

end