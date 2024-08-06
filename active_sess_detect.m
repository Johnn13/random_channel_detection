function [ac_wind] = active_sess_detect(x_1)
    % 该函数用最大的解调窗口进行信号截取


    SF = detect_configs(1);
    BW = detect_configs(2);
    Fs = detect_configs(3);
    N = 2^SF;
    upsampling_factor = Fs/BW;
    n_samp = N * upsampling_factor;
    DC = chirp(false, SF, BW, Fs, 0);
    
    ac_wind = [];
    peak_gain = [];
    amp_thresh = [];
    last_wind = 0;
    front_buf = 6;
    back_buf = 3;

    for i = 1:floor(length(x_1)/n_samp)
        wind = x_1((i-1)*n_samp + (1:n_samp));
        wind_fft = abs(fft(wind .* DC));
%         wind_fft = wind_fft(1:N) + wind_fft(end-N+1:end);
%         debug_sig(wind, false, SF, BW, Fs);
        noise_floor = mean(wind_fft);
        fft_peak = max(wind_fft);
        peak_gain = [peak_gain fft_peak];
        amp_thresh = [amp_thresh 30*noise_floor];
        if (fft_peak > amp_thresh(end))
            if(i > last_wind)
                if(i-back_buf < 1)
                    ac_wind = [ac_wind; 1 i+front_buf];
                else
                    ac_wind = [ac_wind; i-back_buf i+front_buf];
                end
                last_wind = ac_wind(end,2);
            elseif(i <= last_wind)
                ac_wind(end,2) = i + front_buf;
                last_wind = ac_wind(end,2);
            end
        end
    end

    ac_wind = ac_wind.*(n_samp);
    if(ac_wind(end,2) > length(x_1))
        ac_wind(end,2) = length(x_1);
    end

    plot(peak_gain,'linewidth',1.5)
    hold on
    plot(amp_thresh);
    title('Peak Gain Plot');
    set(gca,'linewidth',1.5,'fontsize',25,'fontname','Times New Roman');
    xlabel('Samples','FontSize',30);
    set(gca,'YDir','normal');
    set(gcf,'Color','w');
    ylabel('Peak Gain Magnitude','FontSize',30);
    grid minor
    ylim([0 max(peak_gain)])
end