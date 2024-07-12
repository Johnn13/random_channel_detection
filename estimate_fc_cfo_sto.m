function [fc, cfo, sto] = estimate_fc_cfo_sto(cpacket_list)
    % 该函数通过提取cpacket的preamble_symbols和downchirp_symbols
    % 结合up*down的方法来计算中心频率、CFO、窗口偏移量、STO等等
    
    % LoRa params
    SF = detect_configs(1);
    BW = detect_configs(2);
    Fs = detect_configs(3);
    N = 2 ^ SF * Fs / BW;
    % FFT params
    zero_padding = detect_configs(11);
    nfft = N*zero_padding;

    for i = 1:length(cpacket_list)
        % 逐个对 cpacket_list 中的 cpacket 进行处理
        cpkt = cpacket_list(i);
        up_csym = cpkt.preamble_symbols(1);
        dn_csym = cpkt.downchirp_symbols(1);

        % 只取完全落在demod window 中的peak进行估计
        x1 = filter_by_threshold(up_csym);
        x2 = filter_by_threshold(dn_csym);
        x3 = x1+x2;
        x4 = x2-x1;
        
        % fc_offset_bin 为中心频率偏移导致的bin偏移,并根据bin偏移量算出实际的中心频率偏移量
        % win_offset_bin 为窗口偏移量导致的bin偏移,并根据bin偏移量算出实际的采样点偏移量
        fc_offset_bin = mean(x3/2) - nfft/2;
        win_offset_bin = mean(x4/2);
        fc = (fc_offset_bin - 1) / nfft * Fs;
        win_offset = win_offset_bin / zero_padding * Fs / BW;
        cpkt.fc_offset = fc;
        cpkt.win_offset = win_offset;
    end
end

function y = filter_by_threshold(csym)
    % 根据detect_config中对max_height_thresold的定义
    % 求出csym的pk_height_trking中那些值与最大值差不多大的元素
    % 并将对应的pk_idx_trking, 保存到 y 中
    max_height_thresold = detect_configs(10);

    tmp_pk_height_trking = csym.pk_height_trking;
    [max_height, ~] = max(tmp_pk_height_trking);
    max_height_index = tmp_pk_height_trking > max_height*max_height_thresold;
    y = csym.pk_idx_trking(max_height_index);
end

