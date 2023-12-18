classdef saveFileOperation
    %% this class is for save operation system
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
    % properties: basic settings
    properties
        figureFormat = {'.fig', '.jpg', '.png', '.eps', '.pdf', '.tif'} % figure format
    end

    %% methods
    methods
        %% initialise
        function obj = saveFileOperation
        end
    end

    %% static methods
    methods(Static)
        %% save figures
        function saveFigures(figHandle, filePath)
            % create new figure object
            f1 = figure('Color',[1 1 1]);
            set(f1,'unit','centimeters','position',[3,2,24,18],...
                'PaperUnits','centimeters','PaperOrientation','landscape',...
                'PaperSize',[24,18]);
            newAxes = axes(f1);

            % get UIAxes
            copyobj(figHandle.Children, newAxes);

            % title, label, legend
            set(newAxes, 'TickLabelInterpreter', 'latex');
            title(newAxes, figHandle.Title.String, 'FontSize', 14, 'FontWeight', 'bold', 'Interpreter', 'latex');
            xlabel(newAxes, figHandle.XLabel.String, 'FontSize', 12, 'FontWeight', 'bold', 'Interpreter', 'latex');
            ylabel(newAxes, figHandle.YLabel.String, 'FontSize', 12, 'FontWeight', 'bold', 'Interpreter', 'latex');
            legend(newAxes, figHandle.Legend.String, 'Location', figHandle.Legend.Location, 'Interpreter', 'latex');

            % set the new object
            set(newAxes, 'YScale', figHandle.YScale);
            newAxes.XScale = figHandle.XScale;
            newAxes.FontWeight = 'bold';
            newAxes.XGrid = 'on';
            newAxes.XMinorGrid = 'on';
            newAxes.YGrid = 'on';
            newAxes.YMinorGrid = 'on';
            newAxes.Box = 'on';
            axis(newAxes, 'padded');

            % save: switch condition on extension
            [~, ~, ext] = fileparts(filePath);
            switch ext
                case {'.fig', '.jpg', '.png', '.eps', '.tif'}
                    saveas(f1, filePath);
                case {'.pdf'}
                    exportgraphics(f1, filePath, 'ContentType', 'vector');
                otherwise
                    % do nothing
            end

            % close the current plotting figure
            close(f1)
        end

        %% save tables
        function saveTables(tabHandle, filePath)
            % save tables
            writetable(tabHandle, filePath, "FileType", "spreadsheet", "WriteRowNames", true);
        end

        %% check if file exists
        function checkFileandSave(fileHandle, filePath)
            % get filepath parts
            [~, name, ext] = fileparts(filePath);

            % check if the file exists
            if exist(filePath, "file")
                % ask if want to keep
                message = [name, ext, ' has already existed. Do you want to replace it?'];
                answer = questdlg(message, 'Warning!', 'Yes', 'No', 'No');
                switch answer
                    case 'Yes'
                        if istable(fileHandle)
                            saveFileOperation.saveTables(fileHandle, filePath);
                        else
                            saveFileOperation.saveFigures(fileHandle, filePath);
                        end
                    otherwise
                        % do nothing
                end

            else
                if istable(fileHandle)
                    saveFileOperation.saveTables(fileHandle, filePath);
                else
                    saveFileOperation.saveFigures(fileHandle, filePath);
                end
            end
        end

        %% export main app as a pdf file
        function exportApptoPDF(appFigure)
            filter = {'*.jpg';'*.png';'*.tif';'*.pdf'};
            [filename,filepath] = uiputfile(filter);
            if ischar(filename)
                exportapp(appFigure,[filepath filename]);
            end
        end


    end

end