function [yresidual] = getexcitation(stimulationamplitude, Vpp, Hill5dofMLEparameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Estimate the excitation level and the p vlaue for that level from a
%   stimulus-response pair and the entire regression curve.
%   => get excitation over time
%
    debug_on = false;

    
    sigma_y = Hill5dofMLEparameters(6);

    Hill5dof_fct = @(parameters, x) myreplace_naninf( parameters(1) + (parameters(2)-parameters(1))./( 1 + parameters(3)./( (x-parameters(5)).*((x-parameters(5))>0) ).^parameters(4) ) );

    yresidual = log10(Vpp) - Hill5dof_fct(Hill5dofMLEparameters, stimulationamplitude);
    
   
end
    
    