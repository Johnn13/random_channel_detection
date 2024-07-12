function plot_timefrequency(signal, fs, sf, bw)
    % 画出的时频图
    win_length = 2 ^ (sf - 2);
    Ts = 2 ^ (sf) / bw;
    nfft = fs * Ts;
    zero_padding = 1;
    [s f t] = spectrogram(signal, win_length, round(win_length * 0.95), zero_padding * nfft);
    s = fftshift(s, 1);
    x = [1 nfft];
    y = [-bw/2 bw/2]/1e3;
    imagesc(x, y, abs(s));
    colormap hot;
    title('time frequency','FontSize',35);
    xlabel('PHY Samples', 'Fontsize', 30);
    ylabel('Frequency/(kHz)', 'Fontsize', 30);
    set(gca, 'ydir', 'normal');
    set(gca, 'fontsize',25,'fontname','Times New Roman');
end
