function [mylikelihood_full, mylikelihood_yonly, mylikelihood_xonly] = HillEIV5p2DOF(parameters, xivec, yivec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       Calculates the cond. probability / likelihood for a certain
%       combination of (xivec, yivec) given the parameters and the model,
%       i.e. p(xivec,yivec|model, parameters).
%
%       p1 + (p2-p1)/(1 + p3/((x-p5)^p4)
%       when p5 = 0 leads to common standard Emax function (4 model parameters pulse 2 variability parameters)
%       p6:     y standard deviation (in case of Gaussian) / y normalization
%       p7:     x standard deviation (in case of Gaussian) / x normalization
%       xivec:  x values
%       yivec:  y values, corresponding to xivec (pair-wise) -- or one
%               xivec value and n yivec values
%       dyDistribFun: error distribution, e.g. @normpdf for y-axis
%       dxDistribFun: error distribution, e.g. @normpdf for x-axis

%%%%%%%%%%%%%%%% Main Function %%%%%%%%%%%%%%%%%%%%
    if length(xivec) == 1
        % in this case, all yivec values are for the same xivec:
        [mylikelihood_full, mylikelihood_yonly, mylikelihood_xonly] =...
            HillEIV5p2DOF_singleval(parameters, xivec, yivec);
    else
        % if more than one x, do it step by step
        mylikelihood_full = zeros(1, length(xivec));
        mylikelihood_yonly = zeros(1, length(xivec));
        mylikelihood_xonly = zeros(1, length(xivec));
        for icnt = 1:length(xivec)
            [mylikelihood_full(icnt), mylikelihood_yonly(icnt), mylikelihood_xonly(icnt)] =...
                HillEIV5p2DOF_singleval(parameters, xivec(icnt), yivec(icnt));
        end
    end


end
