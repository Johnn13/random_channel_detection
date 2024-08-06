function [snr_db,nPow,sPow] = cal_snr(dechirp_wind, Fs, BW, SF)
    %CALSNR estimate the SNR of a received LoRa packet
    
    % LoRa modulation & sampling parameters
    N = 2 ^ SF;
    os_factor = Fs / BW;
    nsamp = N * os_factor;
    orig_fft = fft(dechirp_wind);
        
    if os_factor > 1
        fold_fft = orig_fft(1:N) + orig_fft(end-N+1:end);
    else
        fold_fft = orig_fft;
    end

    % ===== 归一化能量 =====
    orig_ft_enr = abs(orig_fft).^2/nsamp;
    fold_ft_enr = abs(fold_fft).^2/nsamp;

    % ===== 将两个 fft 峰值叠加后计算 SNR =====
    enr_total_orig = sum(orig_ft_enr);
    enr_sig_fd = max(fold_ft_enr);
    sPow = enr_sig_fd;
    nPow = enr_total_orig - enr_sig_fd;
    snr_db = 10*log10(sPow / nPow);
    disp(['DEBUG INFO: SNR: ' num2str(snr_db) ' nPow: ' num2str(nPow) ' sPow: ' num2str(sPow) ' ']);
end
