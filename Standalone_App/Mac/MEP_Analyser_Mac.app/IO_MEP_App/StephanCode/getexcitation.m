function [excitationlevel, pvalue, yresidual] = getexcitation(stimulationamplitude, Vpp, Hill5p2EIVparameters)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Estimate the excitation level and the p vlaue for that level from a
%   stimulus-response pair and the entire regression curve.
%   => get excitation over time
%
    debug_on = false;

    sigma_x = Hill5p2EIVparameters(7);
    sigma_y = Hill5p2EIVparameters(6);

    Hill5dof_fct = @(parameters, x) myreplace_naninf( parameters(1) + (parameters(2)-parameters(1))./( 1 + parameters(3)./( (x-parameters(5)).*((x-parameters(5))>0) ).^parameters(4) ) );

    mycrossingfct = @(x) abs( Hill5dof_fct(Hill5p2EIVparameters,x) - (log10(Vpp)-Hill5p2EIVparameters(6)/Hill5p2EIVparameters(7)*(x - stimulationamplitude)) );
    dbg_sampleline = @(x) (log10(Vpp)-Hill5p2EIVparameters(6)/Hill5p2EIVparameters(7)*(x - stimulationamplitude));


    crossingx = fminsearch(mycrossingfct, Hill5p2EIVparameters(5));

    excitationlevel = crossingx - stimulationamplitude;
    % p value: chance that point on curve is pushed up or down to log(Vpp)
    % or beyond only because of sigma_y
    pvalue = normcdf(-1*abs( log10(Vpp) - Hill5dof_fct(Hill5p2EIVparameters, stimulationamplitude) ), 0, sigma_y);
%     pvalue = -1*abs( log10(Vpp) - Hill5dof_fct(Hill5p2EIVparameters, stimulationamplitude) )/ sigma_y;
    yresidual = log10(Vpp) - Hill5dof_fct(Hill5p2EIVparameters, stimulationamplitude);
    
    
    
    
    % debug plot
    if debug_on
        testx = linspace(0, 100, 1000);
        testy = Hill5dof_fct(Hill5p2EIVparameters, testx);
        testc = mycrossingfct(testx);
        testl = dbg_sampleline(testx);
        figure
            subplot(2,1,1)
                plot(testx, testc, 'k')
                box on
                ylabel('abs distance')
            subplot(2,1,2)
                hold on
                plot(testx, 10.^testy, 'k')
                plot(stimulationamplitude, Vpp, 'xr')
                plot(testx, 10.^testl, 'g-')
                plot(crossingx, 10.^Hill5dof_fct(Hill5p2EIVparameters, crossingx), 'ok')
                box on
                set(gca, 'xscale', 'lin', 'yscale', 'log')
                xlabel('Stimulation amplitude')
                ylabel('V_{pp} (V)')
                legend('Hill curve', 'Sample', 'Probe line', 'Intersection')
    end
end
    
    