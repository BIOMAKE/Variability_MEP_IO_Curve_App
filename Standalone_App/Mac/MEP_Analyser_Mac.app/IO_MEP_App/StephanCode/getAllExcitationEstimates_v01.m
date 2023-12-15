
%%
load('1st_full_exp\emgvariability_12172013_CurrentAxis\Regressionresults_01_20190108T203202.mat')

    c(1).curr = myeivdata_c03( myvalidvec03 );
    c(1).vpp = myeivdata_y03( myvalidvec03 );
    c(1).thresh = mle_t_estimation_03;
    c(1).p5 = regressionresults_3pulses.Hill5p2EIV.optimparamsEIV(5);
    
    c(2).curr = myeivdata_c06( myvalidvec06 );
    c(2).vpp = myeivdata_y06( myvalidvec06 );
    c(2).thresh = mle_t_estimation_06;
    c(2).p5 = regressionresults_6pulses.Hill5p2EIV.optimparamsEIV(5);

    
    % get every sample and then extract the excitation and p values for
    % each; plot excitation over time, scale x correctly!
    for scnt = 1:length(c(2).curr)
        [c(2).excitation_estim(scnt), c(2).excitation_pvalue(scnt)] = getexcitation(c(2).curr(scnt) *1e4, c(2).vpp(scnt), regressionresults_6pulses.Hill5p2EIV.optimparamsEIV);
    end
    
    
%%
load('2nd_full_exp\dataset_05212014_CurrentAxis\Regressionresults_01_20190108T035352.mat')

    c(3).curr = myeivdata_c03( myvalidvec03 );
    c(3).vpp = myeivdata_y03( myvalidvec03 );
    c(3).thresh = mle_t_estimation_03;
    c(3).p5 = regressionresults_3pulses.Hill5p2EIV.optimparamsEIV(5);
    
    c(4).curr = myeivdata_c06( myvalidvec06 );
    c(4).vpp = myeivdata_y06( myvalidvec06 );
    c(4).thresh = mle_t_estimation_06;
    c(4).p5 = regressionresults_6pulses.Hill5p2EIV.optimparamsEIV(5);

    
    
    % get every sample and then extract the excitation and p values for
    % each; plot excitation over time, scale x correctly!
    for scnt = 1:length(c(4).curr)
        [c(4).excitation_estim(scnt), c(4).excitation_pvalue(scnt)] = getexcitation(c(4).curr(scnt) *1e4, c(4).vpp(scnt), regressionresults_6pulses.Hill5p2EIV.optimparamsEIV);
    end
    
    
%%
load('3rd_full_exp\dataset_05282014_CurrentAxis\Regressionresults_01_20190108T033813.mat')

    c(5).curr = myeivdata_c03( myvalidvec03 );
    c(5).vpp = myeivdata_y03( myvalidvec03 );
    c(5).thresh = mle_t_estimation_03;
    c(5).p5 = regressionresults_3pulses.Hill5p2EIV.optimparamsEIV(5);
    
    c(6).curr = myeivdata_c06( myvalidvec06 );
    c(6).vpp = myeivdata_y06( myvalidvec06 );
    c(6).thresh = mle_t_estimation_06;
    c(6).p5 = regressionresults_6pulses.Hill5p2EIV.optimparamsEIV(5);

    
    
    % get every sample and then extract the excitation and p values for
    % each; plot excitation over time, scale x correctly!
    for scnt = 1:length(c(6).curr)
        [c(6).excitation_estim(scnt), c(6).excitation_pvalue(scnt)] = getexcitation(c(6).curr(scnt) *1e4, c(6).vpp(scnt), regressionresults_6pulses.Hill5p2EIV.optimparamsEIV);
    end
    
%%
load('4th_full_exp\dataset_06122014_CurrentAxis\Regressionresults_01_20190108T023246.mat')

    c(7).curr = myeivdata_c03( myvalidvec03 );
    c(7).vpp = myeivdata_y03( myvalidvec03 );
    c(7).thresh = mle_t_estimation_03;
    c(7).p5 = regressionresults_3pulses.Hill5p2EIV.optimparamsEIV(5);
    
    c(8).curr = myeivdata_c06( myvalidvec06 );
    c(8).vpp = myeivdata_y06( myvalidvec06 );
    c(8).thresh = mle_t_estimation_06;
    c(8).p5 = regressionresults_6pulses.Hill5p2EIV.optimparamsEIV(5);

    
    
    % get every sample and then extract the excitation and p values for
    % each; plot excitation over time, scale x correctly!
    for scnt = 1:length(c(8).curr)
        [c(8).excitation_estim(scnt), c(8).excitation_pvalue(scnt)] = getexcitation(c(8).curr(scnt) *1e4, c(8).vpp(scnt), regressionresults_6pulses.Hill5p2EIV.optimparamsEIV);
    end
    
%%
load('5th_full_exp\dataset_06182014_CurrentAxis\Regressionresults_01_20190108T040908.mat')

    c(9).curr = myeivdata_c03( myvalidvec03 );
    c(9).vpp = myeivdata_y03( myvalidvec03 );
    c(9).thresh = mle_t_estimation_03;
    c(9).p5 = regressionresults_3pulses.Hill5p2EIV.optimparamsEIV(5);
    
    c(10).curr = myeivdata_c06( myvalidvec06 );
    c(10).vpp = myeivdata_y06( myvalidvec06 );
    c(10).thresh = mle_t_estimation_06;
    c(10).p5 = regressionresults_6pulses.Hill5p2EIV.optimparamsEIV(5);

    
    
    % get every sample and then extract the excitation and p values for
    % each; plot excitation over time, scale x correctly!
    for scnt = 1:length(c(10).curr)
        [c(10).excitation_estim(scnt), c(10).excitation_pvalue(scnt)] = getexcitation(c(10).curr(scnt) *1e4, c(10).vpp(scnt), regressionresults_6pulses.Hill5p2EIV.optimparamsEIV);
    end
    
%%

% now plot all three


figure
    hold on
    plot(c(1).curr, c(1).vpp, 'sk')
    plot(c(2).curr, c(2).vpp, 'ok')
    plot(c(3).curr, c(3).vpp, 'dk')
    plot(c(4).curr, c(4).vpp, '^k')
    plot(c(5).curr, c(5).vpp, 'vk')
    plot(c(6).curr, c(6).vpp, 'pk')
    plot(c(7).curr, c(7).vpp, 'hk')
    plot(c(8).curr, c(8).vpp, 'xk')
    plot(c(9).curr, c(9).vpp, '>k')
    plot(c(10).curr, c(10).vpp, '<k')
    box on
    xlabel('Stimulation current (mA)')
    ylabel('MEP amplitude (V)')
    set(gca, 'YScale', 'log')
    
    
figure
    hold on
    plot(c(1).curr/c(1).thresh, c(1).vpp, 'sk')
    plot(c(2).curr/c(2).thresh, c(2).vpp, 'ok')
    plot(c(3).curr/c(3).thresh, c(3).vpp, 'dk')
    plot(c(4).curr/c(4).thresh, c(4).vpp, '^k')
    plot(c(5).curr/c(5).thresh, c(5).vpp, 'vk')
    plot(c(6).curr/c(6).thresh, c(6).vpp, 'pk')
    plot(c(7).curr/c(7).thresh, c(7).vpp, 'hk')
    plot(c(8).curr/c(8).thresh, c(8).vpp, 'xk')
    plot(c(9).curr/c(9).thresh, c(9).vpp, '>k')
    plot(c(10).curr/c(10).thresh, c(10).vpp, '<k')
    box on
    xlabel('Normalized stimulation current')
    ylabel('MEP amplitude (V)')
    set(gca, 'YScale', 'log')
    title('Norm to 500 µV')
 
    
figure
    hold on
    plot(c(1).curr/c(1).p5, c(1).vpp, 'sk')
    plot(c(2).curr/c(2).p5, c(2).vpp, 'ok')
    plot(c(3).curr/c(3).p5, c(3).vpp, 'dk')
    plot(c(4).curr/c(4).p5, c(4).vpp, '^k')
    plot(c(5).curr/c(5).p5, c(5).vpp, 'vk')
    plot(c(6).curr/c(6).p5, c(6).vpp, 'pk')
    plot(c(7).curr/c(7).p5, c(7).vpp, 'hk')
    plot(c(8).curr/c(8).p5, c(8).vpp, 'xk')
    plot(c(9).curr/c(9).p5, c(9).vpp, '>k')
    plot(c(10).curr/c(10).p5, c(10).vpp, '<k')
    box on
    xlabel('Normalized stimulation current')
    ylabel('MEP amplitude (V)')
    set(gca, 'YScale', 'log')
    title('Norm to p_5')
    
    
    
for icnt = [2,4,6,8,10];
    tm_corrcoeff = corrcoef(c(icnt).excitation_estim(1:end-1), c(icnt).excitation_estim(2:end));
    figure
        subplot(4,1,1:2)
            plot(c(icnt).excitation_estim *1e-4, 'ks-')
            xlim([0, length(c(icnt).excitation_estim)])
            box on
            %xlabel('Sample')
            ylabel('Excitation')
            title(['Animal ' num2str(icnt/2) '; inter-pulse correlation: ' num2str(tm_corrcoeff(1,2))])
%         subplot(4,1,3)
%             plot([0 abs(diff(c(icnt).excitation_estim)) *1e-4], 'kx-')
%             xlim([0, length(c(icnt).excitation_estim)])
%             box on
%             set(gca, 'YScale', 'log')
%             %xlabel('Sample')
%             ylabel('Excitation change')
        subplot(4,1,3)
            bar(c(icnt).excitation_pvalue)
            xlim([0, length(c(icnt).excitation_estim)])
            box on
            xlabel('Stimulus')
            ylabel('p value')
        subplot(4,1,4)
            excitation_fft = fft(c(icnt).excitation_estim *1e-4);
            plot(abs(excitation_fft(1:(length(excitation_fft)/2+1))), 'k-')
            xlabel('Frequency (samples^{-1})')
            ylabel('Amplitude')
            box on
            set(gca, 'xScale', 'log')
            
end
        