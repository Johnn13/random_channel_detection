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

%% load filter coe
% filter62 = load("filter/62k_Filter.mat").Num';
filter125 = load("filter/JM_125k_Filter.mat").Num';
filter250 = load("filter/JM_250k_Filter.mat").Num';
filter500 = load("filter/JM_500k_Filter.mat").Num';

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
    figure;
    plot_timefrequency(x_1,Fs,SF,BW);
%     x_2 = conv(x_1,filter125,'full');

%     figure;
%     plot_timefrequency(x_2,Fs,SF,BW);
    cpacket_list = detect(x_1, 1);
    estimate_fc_cfo_sto(cpacket_list);
% end

%%  Filter and compensate central frequency offset
for i = 1:length(cpacket_list)
    Refine_sig = x_1;
    cpacket_list(i).show();
    fc_offset = cpacket_list(i).fc_offset;
    tt = (1:length(Refine_sig))/Fs;
    tt = tt';
    Refine_sig = Refine_sig .* exp(-1j * 2*pi * (fc_offset) * tt);
    switch cpacket_list(i).BW
        case 125e3
            Refine_sig = conv(Refine_sig,filter125,'full');
        case 250e3
            Refine_sig = conv(Refine_sig,filter250,'full');
        case 500e3
            Refine_sig = conv(Refine_sig,filter500,'full');
        otherwise
            warning("Oops! illegitimate BW")
    end
    figure;
    plot_timefrequency(Refine_sig,Fs,SF,BW);
end




