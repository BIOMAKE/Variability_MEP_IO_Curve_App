% This is a sample instruction script
% Introduce the usage of main classes: modelCalibration, Hill5PCurveModel,
% figureOperation;
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
%
%%
clear
addpath("Functions\") % change the path including functions used in this sample code if necessary

%% simulate a virtual subject database.
% Parameters are obtained from the following study:
% Goetz SM, Peterchev AV. A model of variability in brain stimulation evoked responses.
% In2012 Annual International Conference of the IEEE Engineering in Medicine and Biology Society 2012 Aug 28 (pp. 6434-6437). IEEE.
modelParameters = [-2.02, 0.592, 143, 2.44, 50.2, 0.0793, 3.04];
% standard deviation for Vx and Vy
sigma_y = modelParameters(6);
sigma_x = modelParameters(7);

% number of inputs
noInputs = 40;
noVx = 20;

% x range - [0, 100]
x = linspace(0, 100, noInputs);
x = repmat(x, noVx, 1);
x = reshape(x, 1, numel(x));

% variability along x-axis, sigmax = 3.04
vx = normrnd(0, sigma_x, 1, noVx*noInputs);

% variability along y-axis, sigmay = 0.0793
vy = normrnd(0, sigma_y, 1, noInputs*noVx);

% input of the model
xivec = x + vx;

% output of the model
yivec = Hill5PCurveModel.modelCurveFunction(modelParameters, xivec);

% real outputs
y = 10.^(yivec + vy);


%% Usage of Model class: Hill5PCurveModel()
% Load and initialise the class
myModel = Hill5PCurveModel();
myModel.initialiseModel(x, log10(y))
vx_selected = true;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Static Function: calculateLikelihoodDistribution
% calculate the y probability density dirstribution for a given x
[full_distribution, Y_corresp] = myModel.calculateLikelihoodDistribution(modelParameters, 6, vx_selected);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Static Function: calculateQuantile
% calculate the 95% CI of the model
Yquantile = myModel.calculateQuantile(modelParameters, 100, vx_selected);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Static Function: getExcitation
% calculate the excitability level and corresponding p-value for a single
% pair of (x, y)
[excitationLevel, pvalue, yresidual] = myModel.getExcitation(x(1), log10(y(1)), modelParameters);


%% Model calibration class
% Initialise the modelCalibration class
modelClass = modelCalibration;

% set the options in the class
modelClass.vx_selected = true;
modelClass.selectedCurveModelValue = myModel.modelName;
modelClass.selectedOptimisationMethodValue = 'Particle-Swarm';
modelClass.maximumIteration = 200;

% load the dataset and run the optimisation
modelClass.loadData(x, log10(y));
modelClass.runCalibration()

% get the optimal parameters using MLE
optiParameters = modelClass.opti_parameters_maximumlikelihood;


%% Usage of figureOperation class
% creat empty figure with three axes
fig1 = tiledlayout(1, 3, "Padding", "compact", "TileSpacing", "compact");
% get axes
a1 = nexttile(fig1, 1);
a2 = nexttile(fig1, 2);
a3 = nexttile(fig1, 3);

% Creat a figure class and load the data
figureClass = figureOperation;
figureClass.loadData(x, log10(y));

% initialise all axes' format
figureClass.initialiseFigures(a1, a2, a3)

% Plot logarithmic MEP IO curve with variability
figureClass.plotMEPIOCurveVariability(a1, optiParameters, myModel.modelName, true)

% Plot excitability and its corresponding p-value
figureClass.plotExcitabilityLevel(a2, a3, optiParameters, myModel.modelName)
