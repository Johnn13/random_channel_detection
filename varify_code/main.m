
clc
% close all
clear all
addpath("../");


%%  Loading File
path = '../../../sig/ideal_sig/test/';
fil_nm = 'sf7_bw125k_freq915_cr48.cfile'
filename = [path fil_nm];
x_1 = f_read(filename);

%% Loading variables

% radio variables
Fs = 1e6;
Fc = 915e6;

% detect chirp variables
SF_D = 12;
BW_D = 500e3;
N_D = 2^SF_D;
upsampling_factor_D = Fs / BW_D;
nsamp_D = N_D * upsampling_factor_D;

% practical chirp variables
SF = 7;
BW = 125e3;
N = 2^SF;
upsampling_factor = Fs / BW;
nsamp = N * upsampling_factor;

%%  Active Sessions Detection using Dechirping Windows
uplink_wind = active_wind_detect(x_1);
% uplink_wind = active_sess_split(uplink_wind, 10 * nsamp * upsampling_factor, 2.5 * upsampling_factor * N);    % split up sessions longer than 10 times packet length
disp(['Detected ' num2str(size(uplink_wind,1)) ' active sessions'])

save_rate_c = [];
save_rate_n = [];
for Rsnr = 5:-1:-25
s_count_c = 0;
s_count_n = 0;
for m = 1:size(uplink_wind,1)
    disp(' ')
    disp(['Active Session no. ' num2str(m)])
    disp(['SNR: ' num2str(Rsnr)])
    x_2 = x_1(uplink_wind(m,1) : uplink_wind(m,2)); 
    
    % add {snr} level noise
    x_3 = add_noise(x_2, Rsnr);
    figure;
    plot_timefrequency(x_3,Fs, SF, BW);
    % === conventional detection method === 
%     phy.sig = resample(x_3, 2*BW, Fs);
%     x = detect(x_3, SF, BW, Fs, 7, nsamp);
%     disp(['detect index: ' num2str(x)])
%     if x ~= -1
%         s_count_c = s_count_c+1;
%         disp('detect(conventional) successfully!')
%     end
   
    % === new detection method === 
    x = detect_n(x_3, SF_D, BW_D, Fs, 5, nsamp);
    if x ~= -1
        s_count_n = s_count_n+1;
        disp('detect(new) successfully!')
    end
end
total_count = 43;
s_rate_c = s_count_c/total_count;
s_rate_n = s_count_n/total_count;
save_rate_c = [save_rate_c s_rate_c];
save_rate_n = [save_rate_n s_rate_n];
end
% save('../result/c_9.mat','save_rate_c');
save('../result/n_10_2.mat','save_rate_n');

function x = detect_n(sig, SF, BW, Fs, preamble_len, window_step)
    nsamp = 2^SF * Fs / BW;
    bin_num = 2^SF;
    ii = 1;
    % pk_bin_list 每一列为一个window的解调结果
    first_chirp_bin_list =[];
    pk_bin_list = [];
    while ii < length(sig)-nsamp*preamble_len
        if length(pk_bin_list) == preamble_len - 2
            x = ii;
            return;
        end
        % pk 的第一行是峰值的index，第二行是峰值的value
        pk = dechirp(sig(ii:ii+nsamp-1), SF, BW, Fs);
%         first_chirp_bin_list
%         pk_bin_list
        if isempty(pk)
            first_chirp_bin_list =[];
            pk_bin_list = [];
            ii = ii + window_step;
            continue;
        end
        if isempty(first_chirp_bin_list)
            % 如果第一个chirp还没拿到,则新建
            first_chirp_bin_list = pk(:,1);
            ii = ii + window_step;
            continue;
        end
        if ~isempty(pk_bin_list)
             % 如果pk_bin_list已经有追踪的峰值
           ismatch = false;
           for jj = 1:size(pk,1)
               bin_diff = mod(pk_bin_list(end)-pk(jj,1), bin_num);
               if bin_diff > bin_num/2
                   bin_diff = bin_num - bin_diff;
               end
               if bin_diff <= 2
                   pk_bin_list = [pk_bin_list; pk(jj,1)];
                   ismatch = true;
                   break;
               end
           end
           if ~ismatch
               first_chirp_bin_list = pk(:,1);
               pk_bin_list = [];
           end
        else
            % 如果pk_bin_list还没有追踪的峰值，则和第一个chirp比较
            ismatch = false;
            for jj = 1:size(pk,1)
                bin_diff = mod(first_chirp_bin_list-pk(jj,1), bin_num);
                if sum(bin_diff > bin_num/2) > 0
                    bin_diff(bin_diff > bin_num/2) = bin_num - bin_diff(bin_diff > bin_num/2) ;
                end
                if sum(bin_diff <= 2) > 0
                    pk_bin_list = pk(jj,1);
                    ismatch = true;
                    break;
                end
            end
            if ~ismatch
                first_chirp_bin_list = pk(:,1);
                pk_bin_list = [];
            end
        end
        ii = ii + window_step;
    end
    x = -1;
end


function x = detect(sig, SF, BW, Fs, preamble_len, window_step)
    % detect  Detect preamble
    nsamp = 2^SF * Fs / BW;
    bin_num = 2^SF;
    ii = 1;
    pk_bin_list = []; % preamble peak bin list
    
    while ii < length(sig)-nsamp*preamble_len
        % search preamble_len-1 basic upchirps
        if length(pk_bin_list) == preamble_len - 1
            x = ii;
            return;
        end
        pk0 = dechirp(sig(ii:ii+nsamp-1), SF, BW, Fs);
        if ~isempty(pk_bin_list)
            bin_diff = mod(pk_bin_list(end)-pk0(2), bin_num);
            if bin_diff > bin_num/2
                bin_diff = bin_num - bin_diff;
            end
            if bin_diff <= 1
                pk_bin_list = [pk_bin_list; pk0(2)];
            else
                pk_bin_list = pk0(2);
            end
        else
            pk_bin_list = pk0(2);
        end
        ii = ii + window_step;
    end
    x = -1;
 end

 function pk = dechirp(sig, SF, BW, Fs, is_up)
    % dechirp  Apply dechirping on the symbol starts from index x
    %
    % input:
    %     x: Start index of a symbol
    %     is_up: `true` if applying up-chirp dechirping
    %            `false` if applying down-chirp dechirping
    % output:
    %     pk: Peak in FFT results of dechirping
    %         pk = (height, index)
    
    if nargin == 5 && ~is_up
        c = chirp(true, SF, BW, Fs, 0, 0, 0);
    else
        c = chirp(false, SF, BW, Fs, 0, 0, 0);
    end
    nsamp = 2^SF * Fs / BW;
    bin_num = 2^SF;
    ft = fft(sig.*c);
    ft_ = abs(ft(1:bin_num)) + abs(ft(nsamp-bin_num+1:end));
    pk = get_peak(ft_, 0, 2);
%     pk = topn([ft_ (1:bin_num).'], 1);
%     figure;
%     plot(ft_);
 end

 function y = topn(pks, n, padding, th)
    [y, p] = sort(abs(pks(:,1)), 'descend');
    if nargin == 1
        return;
    end
    nn = min(n, size(pks, 1));
    if nargin >= 3 && padding
        y = [pks(p(1:nn), :); zeros(n-nn, size(pks, 2))];
    else
        y = pks(p(1:nn), :);
    end
    if nargin == 4
        ii = 1;
        while ii <= size(y,1)
            if abs(y(ii,1)) < th
                break;
            end
            ii = ii + 1;
        end
        y = y(1:ii-1, :);
    end
end