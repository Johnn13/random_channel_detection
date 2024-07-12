close all
clear all

%% Loading variables
% chirp variables
SF = param_configs(1);
BW = param_configs(2);
Fs = param_configs(3);
N = 2 ^ SF;

%%  Loading File
path = param_configs(16);
fil_nm = param_configs(17);
filename = [path fil_nm];
x_1 = f_read(filename);

% plotting  signal
% plot(real(x_1),'linewidth',0.75)
% xlabel('time/sec')
% ylabel('real magnitude')
% title('Raw signal');
% plot_timefrequency(x_1, Fs, SF, BW)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [preamble_list symbol_list] = detect(x_1, 1);

a = {symbol_list.peak_list};
% a = a';
% save("symbols.mat","a");
% packet_symbol = demod(x_1, preamble_list, symbol_list);
