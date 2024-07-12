function [cpacket_list] = extract_packet(dc_csymbols_list,uc_csymbols_list)
    %从cymbols数组中检测潜在的数据包
    % 并将preamble upchirp和downchirp对应的csymbol放进对应的cpkt中
    cpacket_list = [];
    for i = 1:length(dc_csymbols_list)
       % 原则: 来自相同cpacket的csymbol的index和height理论上一样
        if length(cpacket_list) == 0
            cpkt = cpacket(dc_csymbols_list(i));
            cpacket_list = [cpacket_list cpkt];
            continue
        end  
        cpkt_match_flag = 0;
        for j = 1:length(cpacket_list)
            tmp_cpkt = cpacket_list(j);
            tmp_preamble_csym = tmp_cpkt.preamble_symbols(end);
            icm = is_csymbol_match(tmp_preamble_csym, dc_csymbols_list(i));
            if icm
                tmp_cpkt.preamble_symbols = [tmp_cpkt.preamble_symbols dc_csymbols_list(i)];
                cpkt_match_flag = 1;
                break
            end
        end  
        if ~cpkt_match_flag 
            % 未匹配到对应的cpacket
            cpkt = cpacket(dc_csymbols_list(i));
            cpacket_list = [cpacket_list cpkt];
        end
    end

    for i = 1:length(cpacket_list)
        cpacket_list(i).show();
    end

    % 消除异常的cpacket
    % 原则: cpacket的preamble_symbols长度非法
    preamble_num = detect_configs(4);
    leg_index = [];
    for i = 1:length(cpacket_list)
        if length(cpacket_list(i).preamble_symbols) > preamble_num-1
            leg_index = [leg_index i];
        end
    end
    cpacket_list = cpacket_list(leg_index);
    % 将downchirp对应csymbol也放进cpacket中
    for i = 1:length(uc_csymbols_list)
        if length(cpacket_list) == 0
            warning("no legitimate cpacket, but having downchirp csymbol!")
            break
        end
        for j = 1:length(cpacket_list)
            tmp_cpkt = cpacket_list(j);
            tmp_preamble_csym = tmp_cpkt.preamble_symbols(1);
            icm = is_csymbol_match(tmp_preamble_csym, uc_csymbols_list(i));
            if icm
                tmp_cpkt.downchirp_symbols = [tmp_cpkt.downchirp_symbols uc_csymbols_list(i)];
                break
            end
        end
    end
    
    for i = 1:length(cpacket_list)
        cpacket_list(i).init();
    end

end

function y = is_csymbol_match(csym_1, csym_2,up_with_down)
    % 原则: 来自相同cpacket的csymbol的index和height理论上一样
    x1 = csym_1.pk_idx_trking;
    y1 = csym_1.pk_height_trking;
    if nargin > 2 && up_with_down
        x1 = filp(x1);
        y1 = filp(y1);
    end
    x2 = csym_2.pk_idx_trking;
    y2 = csym_2.pk_height_trking;
    if length(x1) == length(x2) && length(y1) == length(y2)
        idx_trking_diff = sum(x1 - x2); 
        height_trking_diff = sum(y1 - y2); 
%                 fprintf('\n');
%                 disp([mfilename '[FUNCTION DEBUG]'])
%                 disp(['[DEBUG] idx_trking_diff: ' num2str(idx_trking_diff)])
%                 disp(['[DEBUG] height_trking_diff: ' num2str(height_trking_diff)])
        if idx_trking_diff < 10 && height_trking_diff < 500
            % match!
            y = true;
            return
        end
    end
    y = false;
end