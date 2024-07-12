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
    figure;
    set (gcf,'position',[500,300,1200,550] );
    subplot(231)
    plot_timefrequency(wind,Fs,SF,BW);
    
    subplot(232)
    plot(orig_fft_,'LineWidth', 1.5);
    title('Original FFT Result');
    set(gca,'linewidth',1.5,'fontsize',25,'fontname','Times New Roman');
    xlabel('FFT bin','FontSize',30);
    ylabel('Abs. FFT','FontSize',30);

    subplot(233)
    plot(orig_fft_shift,'LineWidth', 1.5);
    title('FFT Shift Result');
    set(gca,'linewidth',1.5,'fontsize',25,'fontname','Times New Roman');
    xlabel('FFT bin','FontSize',30);
    ylabel('Abs. FFT','FontSize',30);

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