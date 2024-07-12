clc
close all
clear all

%% Loading variables
% chirp variables
SF = param_configs(1);
BW = param_configs(2);
Fs = param_configs(3);
N = 2 ^ SF;
upsampling_factor = Fs/BW;
nsamp = Fs * 2^SF / BW;

%%  Loading File
path = param_configs(16);
fil_nm = param_configs(17);
filename = [path fil_nm];
x_1 = f_read(filename);

%%  Active Sessions Detection using Dechirping Windows
% ac_wind = active_wind_detect(x_1);
% uplink_wind = active_sess_split(uplink_wind, 10 * nsamp * upsampling_factor, 2.5 * upsampling_factor * N);    % split up sessions longer than 10 times packet length
% disp(['Detected ' num2str(size(ac_wind,1)) ' active sessions'])

%%
% for m = 1:size(ac_wind,1)
%     disp(' ')
%     disp(['Active Session no. ' num2str(m)])

%     x_2 = x_1(ac_wind(m,1) : ac_wind(m,2)); 
%     figure;
%     plot_timefrequency(x_1,Fs,SF,BW);
    cpacket_list = detect(x_1, 1);
    estimate_fc_cfo_sto(cpacket_list);
% end

for i = 1:length(cpacket_list)
    cpacket_list(i).show();
end

