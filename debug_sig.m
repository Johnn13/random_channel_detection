function [pk_hight,pk_index] = debug_sig(wind,down,SF,BW,Fs)
            
    N = 2^SF;
    upsampling_factor = Fs/BW;
    nsamp = N * upsampling_factor;
    % FFT variables
    BC = chirp(false,SF,BW,Fs,0);
    if nargin >= 2 && down
        BC = chirp(true,SF,BW,Fs,0);
    end
    zero_padding = 1;

    orig_fft = fft(wind.*BC, nsamp*zero_padding);
    orig_fft_ = abs(orig_fft);
    orig_fft_shift = abs(fftshift(orig_fft));
    % align_win_len = length(orig_fft) / (Fs/BW);
    % fold_fft = orig_fft_(1:align_win_len) + orig_fft_(end-align_win_len+1:end);
    % [pk_hight pk_index] = max(orig_fft_);
    % disp(['DEBUG INFO: pk_hight: ' num2str(pk_hight) ' pk_index: ' num2str(pk_index) ' ']);
    
    % ==== 计算出峰值的位置,以在图像中标出
    detect_th = detect_configs(7);
    MaxPeakNum = detect_configs(8);
    pks1 = get_peak(orig_fft_, detect_th, MaxPeakNum);
    pks2 = get_peak(orig_fft_shift, detect_th, MaxPeakNum);
    
    figure;
    set (gcf,'position',[500,300,1200,550] );
    currentFig = gcf;
    figNumber = currentFig.Number;
    disp(['当前图像窗口是: Figure ', num2str(figNumber)]);
    
    subplot(231)
    plot_timefrequency(wind,Fs,SF,BW);
    
    subplot(232)
    plot(orig_fft_,'LineWidth', 1.5);
    title('Original FFT Result');
    set(gca,'linewidth',1.5,'fontsize',25,'fontname','Times New Roman');
    xlabel('FFT bin','FontSize',30);
    ylabel('Abs. FFT','FontSize',30);
    fprintf('[Original peak]:\n ');
    for i = 1:size(pks1,1)
        hold on
        plot(pks1(i,1), pks1(i,2), 'r*', 'MarkerSize', 20);
        fprintf('\tidx: %6.2f\t value: %6.2f\n',pks1(i,1), pks1(i,2));
    end
    fprintf('\n');

    subplot(233)
    plot(orig_fft_shift,'LineWidth', 1.5);
    title('FFT Shift Result');
    set(gca,'linewidth',1.5,'fontsize',25,'fontname','Times New Roman');
    xlabel('FFT bin','FontSize',30);
    ylabel('Abs. FFT','FontSize',30);
    fprintf('[FFT Shift Result]:\n ');
    for i = 1:size(pks2,1)
        hold on
        plot(pks2(i,1), pks2(i,2), 'r*', 'MarkerSize', 20);
        fprintf('\tidx: %6.2f\t value: %6.2f\n',pks2(i,1), pks2(i,2));
    end
    fprintf('\n');

    subplot(2,3,[4,6])
    plot(real(wind),'LineWidth', 1.5);
    hold on
    plot(imag(wind),'LineWidth', 1.5);
    title('Original signal(time-domain)');
    set(gca,'linewidth',1.5,'fontsize',25,'fontname','Times New Roman');
    xlabel('Samples','FontSize',30);
    ylabel('Ampl','FontSize',30);
    axis tight
end