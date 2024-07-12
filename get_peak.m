function [out] = get_peak(arr, th)
    %GET_MAX, this function returns uptil num_pnts many maximums above
    % 'threshold'
%     temp = arr;
    out = [];
    num_neignbors = 8;
    N = length(arr);
    % num_threshold_part = 16;

    for i = 1:N
        v = arr(i);
%         mean_val = mean(arr);
%         var_val = std(arr);
%         threshold = mean_val + 6 * var_val;
        lidx = mod((i - num_neignbors - 1):(i - 1) - 1, N) + 1;
        ridx = mod(i:i + num_neignbors - 1, N) + 1;
        % th_lidx = mod((i - num_threshold_part - 1):(i - 1) - 1, N) + 1;
        % th_ridx = mod(i:i + num_threshold_part-1, N) + 1;
        % % 局部阈值
        % threshold_part = 1.2*sum(temp([th_lidx th_ridx]))/num_threshold_part;

%         if (v > threshold && sum(temp([lidx ridx]) > v) < 1)
%             arr([lidx i ridx]) = 0;
%             out = [out; i v; ];
%         end
        if (v > th && sum(arr([lidx ridx]) > v) < 1)
%             arr([lidx i ridx]) = 0;
            out = [out; i v; ];
        end
    end
end
