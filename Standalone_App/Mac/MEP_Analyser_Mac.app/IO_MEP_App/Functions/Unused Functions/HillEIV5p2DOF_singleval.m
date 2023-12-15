function [mylikelihood_full, mydistrib_yonly, mydistrib_xonly] = HillEIV5p2DOF_singleval(parameters, xivec, yivec)
%% This function aims to calculate the probability of y given x considering two/one variability sources, either vx or vy.
% This probability could be used to construct the likelihood function for
% a given pair of x and y.
% input arguments:
% parameters: parameters(1) - a, parameters(2) - b, parameters(3) - c,
% parameters(4) - d, parameters(5) - e, parameters(6) - sigma_y (standard
% deviation), parameters(7) - sigma_x (standard deviation)
% xivec - a single x value
% yivec - a single y value
% dyDistribFun - the chosen distirbution function for y-axis (e.g., normal distribution, exponential distribution...)
% dxDistribFun - the chosen distribution function for x-axis
% Note that, in this case, we set normal distribution as default for both
% x- and y-axis.

%% Hill function and its inverse function
% Hill function
myfunction = @(myx) parameters(1) + (parameters(2)-parameters(1))./( 1 + parameters(3)./(1000*eps+ (myx-parameters(5)).*((myx-parameters(5))>0) ).^parameters(4) );
% For the inverse function, the lower limit of y should be larger than
% parameters(1), that is, y > p1. Therefore, for y < p1, we let y = p1 by
% using Heaviside function.
myinversefunction = @(myy) (( parameters(3)*(myy-parameters(1))./(parameters(2)-myy) ).^(1/parameters(4)) + parameters(5)) .*(myy>=parameters(1)) + parameters(1).*(myy<parameters(1));


%% y-axis range and its variability distribution
% First, define the valid range of y: numerically evaluate the density distribution
% The lowest value of y is "parameters(1) - 5.5*parameters(6)";
% The highest value of y is "parameters(2) + 5.5*parameters(6)";
Yrange = linspace(parameters(1)-5.5*parameters(6), parameters(2)+5.5*parameters(6), 1000);

% vy - y variability distribution
% the mean value is Yrange(end/2) - the middle index "end/2"
ydistrib_val = normpdf(Yrange, Yrange(end/2), parameters(6)); % calculate the probability at each y-value
% ydistrib_val = 1/parameters(6)* dyDistribFun((Yrange - Yrange(end/2))/parameters(6));


%% x-axis range and its variability distribution
sigmax = parameters(7); % standard deviation for x-axis
% define the highest and lowest y value
lowestlevel_y = min(parameters(1), parameters(2));
highestlevel_y = max(parameters(1), parameters(2));

% calculate the corresponding x range according to y range
xrange_corresp = real(myinversefunction(Yrange));      
xrange_corresp(Yrange < lowestlevel_y) = xivec - 100*sigmax; % if y-value is too low, the corresponding x-value must be very small.
xrange_corresp(Yrange > highestlevel_y) = xivec + 100*sigmax; % if y-value is too high (saturated), the corresponding x-value must be very high.

% calculate the cumulative distribution value for each x-value
cumultransformedxdistrib_val = normcdf((xrange_corresp - xivec)/sigmax);

% calculate the probability density value for each x-value
% deltaY is (Yrange(2) - Yrange(1)); alternative: mean(diff(Yrange));
transformedxdistrib_val = zeros(size(Yrange));
transformedxdistrib_val(2:end-1) = 1/(2*(Yrange(2)-Yrange(1))) * (cumultransformedxdistrib_val(3:end) - cumultransformedxdistrib_val(1:end-2)); % ./(xrange_corresp(3:end)-xrange_corresp(1:end-2))
%transformedxdistrib_val(2:end-1) = 1/2 * 1/(Yrange(2)-Yrange(1)) * (cumultransformedxdistrib_val(3:end) - cumultransformedxdistrib_val(1:end-2)) .* (xrange_corresp(3:end)-xrange_corresp(1:end-2));



transformedxdistrib_val(1) = 1000*eps;		% not 0 because of log-likelihood
transformedxdistrib_val(end) = 1000*eps;
    
% Make sure the sum of probability distribution along x-axis is one 
transformedxdistrib_val_correct = transformedxdistrib_val / ((Yrange(2)-Yrange(1))*sum(transformedxdistrib_val));
        
%% Calculate the final distribution of output of the system
% at the moment only for equidistant sampling!
fulldistrib = (Yrange(2)-Yrange(1))*myconvnfft(ydistrib_val, transformedxdistrib_val_correct, 'full');
fulldistrib_cut = fulldistrib(round(length(fulldistrib)*1/4:length(fulldistrib)*3/4));      % leads to the same as conv(:,:,'same')

% maybe linear for more speed	
mylikelihood_full = interp1(Yrange, fulldistrib_cut, yivec, 'linear');
mylikelihood_full(isnan(mylikelihood_full)) = 1000*eps;
    
% consider x- or y-variability only
mydistrib_yonly = interp1(Yrange + myfunction(xivec) - Yrange(end/2), ydistrib_val, yivec, 'linear');
mydistrib_xonly = interp1(Yrange, transformedxdistrib_val_correct, yivec, 'linear');

end
