function csym = save_csymbol(tmp_symbol, pk_res_trking)
    % 将 tmp_symbol 仅包含峰值index序列,保存到固定的数据类型 csymbol
    % 通过峰值index,到pk_res_trking中找到对应的pk_res_trking_index

    pk_idx_trking = [];
    pk_height_trking = [];

    for i = 1:size(tmp_symbol,1)
        % 从pk_res_trking 的最后一列开始算起
        
        single_round_pk_res = pk_res_trking(:,:,end-i);
        tmp_pk_index = tmp_symbol(i,:);
        for j = 1:length(tmp_pk_index)
            if single_round_pk_res(tmp_pk_index(j))
                % 本轮fft结果在这些index都有峰值
                pk_idx_trking = [pk_idx_trking, tmp_pk_index(j)];
                pk_height_trking = [pk_height_trking, single_round_pk_res(tmp_pk_index(j),2)];
                break;
            end
        end
    end

    csym = csymbol(flip(pk_idx_trking), flip(pk_height_trking));
%     csym.show();

end