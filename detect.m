function [cpacket_list] = detect(sig, ii)

    % detect window params
    SF = detect_configs(1);
    BW = detect_configs(2);
    Fs = detect_configs(3);
    num_preamble = detect_configs(4);
    detect_th = detect_configs(7);

    N = 2 ^ SF * Fs / BW;
    UC = chirp(true, SF, BW, Fs, 0);
    DC = chirp(false, SF, BW, Fs, 0);
    detect_samp = 2 ^ SF * Fs / BW;
    detect_rate = detect_configs(12);
    detect_step = detect_samp/detect_rate;
%     sample_num_per_symbol = param_configs(9);

    % FFT params
    zero_padding = detect_configs(11);
    detect_nbin = detect_samp * zero_padding;
    pk_step_bin = detect_nbin / detect_rate * BW / Fs * zero_padding; 

    symbol = struct('peak_list', [], 'state', 0);
    preamble = struct('p_symbol_list', [], 'state', 0);
    cur_symbol_list = [];
    symbol_list = [];
    dis_tolerance = 10;

    % detect potential preamble
    preamble_list = [];

    % detect params
    pk_res = zeros(detect_nbin,2);   % 用来存储1次 fft 的结果(index,value)
    dc_pk_res_trking = repmat(pk_res, 1, 1, 2*detect_rate+1);  % 用来存储2*detect_rate-1+2次 fft 的结果(index,value,times)
    uc_pk_res_trking = repmat(pk_res, 1, 1, 2*detect_rate+1);
    dc_csymbols_list = [];
    uc_csymbol_list = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    win_num = 1;
    for i = ii:detect_step:length(sig) - detect_samp
%         disp(['win num: ' num2str(win_num)])
        win_num = win_num + 1;
        sig_dw = sig(i:i + detect_samp - 1);
        % 分别使用 UC 和 DC 进行dechirp
        dc_fr = abs(fftshift(fft(sig_dw .* DC,detect_nbin)));
        uc_fr = abs(fftshift(fft(sig_dw .* UC,detect_nbin)));
        
%         debug_sig(sig_dw,false,SF,BW,Fs);
        tmp_dc_pk_res = pk_res;
        tmp_uc_pk_res = pk_res;
        dc_pks = get_peak(dc_fr,detect_th);
        uc_pks = get_peak(uc_fr,detect_th);

        for it = 1:size(dc_pks,1)    
            tmp_dc_pk_res(dc_pks(it),:) = [1 dc_pks(it,2)];
        end
        for it = 1:size(uc_pks,1)    
            tmp_uc_pk_res(uc_pks(it),:) = [1 uc_pks(it,2)];
        end
        dc_pk_res_trking(:,:,1) = [];
        uc_pk_res_trking(:,:,1) = [];
        dc_pk_res_trking = cat(3, dc_pk_res_trking, tmp_dc_pk_res);
        uc_pk_res_trking = cat(3, uc_pk_res_trking, tmp_uc_pk_res);

        % extract symbols 
        % 1. upchirp symbols
        tmp_symbols = extract_symbol(threed2twod(dc_pk_res_trking),pk_step_bin);
        if ~isempty(tmp_symbols)
            % 此时 tmp_symbols 的历史峰值都在 pk_res_trking 中
            % tmp_symbols 是一个cell数据类型,里面的每个元素都是一个symbol的峰值序列
            for jj = 1:length(tmp_symbols)
                % 遍历cell,对每个symbol进行操作,形成csymbol数据类型
                csym = save_csymbol(tmp_symbols{jj},dc_pk_res_trking, round(i/detect_step));
                dc_csymbols_list = [dc_csymbols_list csym];
            end
        end
        
        % 2. downchirp symbols
        tmp_symbols = extract_symbol(threed2twod(uc_pk_res_trking),-pk_step_bin); % 注意这里是负的步长
        if ~isempty(tmp_symbols)
            for jj = 1:length(tmp_symbols)
                csym = save_csymbol(tmp_symbols{jj},uc_pk_res_trking, round(i/detect_step));
                uc_csymbol_list = [uc_csymbol_list csym];
            end
        end
    end
    
    % 查看symbols中的symbol
%     for i = 1:length(dc_csymbols_list)
%         tmp_csym = dc_csymbols_list(i);
%         tmp_csym.show();
%     end

    % 根据preamble的特性,从symbols中检测潜在的数据包
    cpacket_list = [];
    cpacket_list = extract_packet(dc_csymbols_list,uc_csymbol_list);

end
