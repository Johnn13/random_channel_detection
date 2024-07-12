function symbols= extract_symbols(pk_res_trking, pk_step_bin)
    % 该函数用来获取峰值追踪集合中，是否有潜在的 symbols
    % 判断 symbols 的依据：在多个demod window 的 fft 结果中是否有符合规律的 fft bin
    % 使用3个指针协助追踪峰值:
    %      前指针: 指向symbols的第一轮的上一轮,
    %             用于判定symbol的峰值起始轮次,防止长chirp被误判为短chirp,导致追踪不充分
    %      后指针: 指向symbols的最后一轮的下一轮,
    %             用于判定symbol的峰值结束轮次,防止短chirp被误判为长chirp,导致追踪失败
    %      判定指针: 指向symbol最后一轮
    %               用于判定每一轮的峰值是否符合一个symbol规律

    % 输入：
    %    pk_res_trking:连续窗口的 fft 结果，每一列为一次 fft 结果
    %    pk_step_bin: 连续的窗口中，峰值位置的差距  
    % 输出：
    %    symbols: symbols包含了一个或多个symbol,多个symbols被放进了一个cell数据类型中
    %             一个symbol由一个峰值追踪序列构成
    
    peak_tor = detect_configs(9);

    [nfft pk_trking_length] = size(pk_res_trking); 
    symbols = {}; 
%     disp(['DEBUG: 最后一列不为零的索引为: '])
%     disp(find(pk_res_trking(:,end-1)))
    for i = 1:nfft
        if pk_res_trking(i, end-1)
            % 从倒数第二列开始找,最后一列是后指针,用于判定symbol是否结束
%             disp(['peak index: ' num2str(i)])
            % range 设定了模糊搜索的范围
            range = (i-peak_tor:i+peak_tor);
            idx = mod(range,nfft);
            pk_trace = [idx];
            for k = 1:pk_trking_length-3
                % -3的原因是因为去除前后2个点,以及本身对比位置,最多只需要pk_trking_length-3次比较
                % k 为比较的轮次
                % d 为比较位置的指针
                % p 为前指针,判定symbols是否为长chirp
                % r 为后指针,判定symbols是否结束
                d = pk_trking_length-1-k;
                p = d-1;
                
                r = pk_trking_length;
                range = (i-peak_tor:i+peak_tor);
                idx = mod(range-k*pk_step_bin,nfft);
                pk_trace = [pk_trace;idx];
                idx = idx(idx~=0);  %去除0
%                 disp(['idx: ' num2str(idx)])       
                switch sum(pk_res_trking(idx,d))
                    case 0
                        if k < pk_trking_length/3
                            break;
                        end
                    otherwise
                        p_idx=mod(range-(k+1)*pk_step_bin,nfft);
                        r_idx=mod(range+pk_step_bin,nfft);
                        p_idx = p_idx(p_idx~=0);  %去除0
                        r_idx = r_idx(r_idx~=0);  %去除0
                        if k > pk_trking_length/3 && ~sum(pk_res_trking(p_idx,p)) && ~sum(pk_res_trking(r_idx,r))
                            % 当且仅当前指针、后指针都没有峰值,判定指针有峰值时,才认为锁定symbol
                            % 由于查找是从后往前找,所以最终存储的时候需要反转一下pk_trace的顺序
%                             disp(['DEBUG: 检测到symbols序列!'])
                            symbols{end+1} = pk_trace;
                            break;
                        end         
                end    
            end    
        end
    end
end