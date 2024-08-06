clc
close all
clear all
addpath("../test_code/");


%%  Loading File
path = '../../sig/ideal_sig/test/';
fil_nm = 'sf7_bw125k_freq915_cr48.cfile'
filename = [path fil_nm];
x_1 = f_read(filename);

%% Loading variables

% radio variables
Fs = 1e6;
Fc = 915e6;

% detect chirp variables
SF_D = 11;
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



phy = LoRaPHY(Fc, SF, BW, Fs);
% [symbols_d, cfo, netid] = phy.demodulate(x_1);
% fprintf("[demodulate] symbols:\n");
% disp(symbols_d);

%%  Active Sessions Detection using Dechirping Windows
uplink_wind = active_wind_detect(x_1);
uplink_wind = active_sess_split(uplink_wind, 10 * nsamp * upsampling_factor, 2.5 * upsampling_factor * N);    % split up sessions longer than 10 times packet length
disp(['Detected ' num2str(size(uplink_wind,1)) ' active sessions'])

%%
save_rate_c = [];
save_rate_n = [];

for Rsnr = 5:-1:-40
s_count_c = 0;
s_count_n = 0;
total_count = 0;
for m = 1:2
    disp(' ')
    disp(['Active Session no. ' num2str(m)])
    disp(['SNR: ' num2str(Rsnr)])
    x_2 = x_1(uplink_wind(m,1) : uplink_wind(m,2)); 
    
    total_count = total_count+1;
    % add {snr} level noise
    x_3 = add_noise(x_2, Rsnr);

    % === conventional detection method === 
    phy.sig = resample(x_3, 2*BW, Fs);
    x = phy.detect(1);
    disp(['detect index: ' num2str(x)])
    if x ~= -1
        s_count_c = s_count_c+1;
        disp('detect(conventional) successfully!')
    end
   
    % === new detection method === 
    cpacket_list = detect(x_3, 1);
    if length(cpacket_list) > 0
        s_count_n = s_count_n+1;
        disp('detect(new) successfully!')
    end
end

s_rate_c = s_count_c/total_count;
s_rate_n = s_count_n/total_count;
save_rate_c = [save_rate_c s_rate_c];
save_rate_n = [save_rate_n s_rate_n];
end
save('result/a.mat','save_rate_c');
save('result/a.mat','save_rate_n');
% function conv_detect(sig, Fs, SF, BW)
%     % detect lora packet by conventional method
%     
%     N = 2^SF;
%     Fs_BW_rate =  Fs / BW;
%     nsamp = N * Fs_BW_rate;
%     preamble_len = 8;
%     
%     ii = 1;
%     pk_bin_list =[];
%     while ii < length(sig) - nsamp * preamble_len
%         if length(pk_bin_list) == preamble_len - 1
%             x = ii - round((pk_bin_list(end)-1)*Fs_BW_rate);
%         end
%         pk0 = 
%     end
% end




