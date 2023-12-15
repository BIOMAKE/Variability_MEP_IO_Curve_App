clear
% Generate the traning samples (Goetz model)
modelParameters = [-2.02, 0.592, 143, 2.44, 50.2, 3.04, 0.0793];

% number of inputs
noInputs = 30;
noVx = 6;

% x range - [0, 100]
x = linspace(0, 100, noInputs);
x = repmat(x, noVx, 1);
x = reshape(x, 1, numel(x));

% variability along x-axis, sigmax = 3.04
vx = normrnd(0, 3.04, 1, noVx*noInputs);

% variability along y-axis, sigmay = 0.0793
vy = normrnd(0, 0.0793, 1, noInputs*noVx);

% input of the model
xivec = x + vx;

% output of the model
yivec = modelCurveFunction(modelParameters, xivec);

% real outputs
y = yivec + vy;

% create a table
myTable = table(x', 10.^y', 'VariableNames', ["my_x", "my_y"]);

% write a excel file
fileName = 'mySamplePoints.xlsx';

writetable(myTable, fileName)




% % plot
% figure
% scatter(x, y)











% define the function
function objFunValue = modelCurveFunction(parameters, xivec)

    objFunValue = parameters(1) + (parameters(2)-parameters(1))./( 1 + parameters(3)./((xivec-parameters(5)).*((xivec-parameters(5))>0) ).^parameters(4) );

end