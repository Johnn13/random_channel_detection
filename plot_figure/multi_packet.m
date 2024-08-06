clc
close all
clear all
addpath("../varify_code/");
addpath("../../test_code/")
addpath("../");

%% Loading variables

% radio variables
Fs = 1e6;
Fc = 915e6;

% detect chirp variables
SF_1 = 9;
BW_1 = 250e3;
N_1 = 2^SF_1;
upsampling_factor_1 = Fs / BW_1;
nsamp_1 = N_1 * upsampling_factor_1;

SF_2 = 7;
BW_2 = 125e3;
N_2 = 2^SF_2;
upsampling_factor_2 = Fs / BW_2;
nsamp_2 = N_2 * upsampling_factor_2;

SF_3 = 9;
BW_3 = 250e3;
N_3 = 2^SF_3;
upsampling_factor_3 = Fs / BW_3;
nsamp_3 = N_3 * upsampling_factor_3;

phy1 = LoRaPHY(Fc, SF_1, BW_1, Fs);
phy1.has_header = 1;         
phy1.cr = 4;                 
phy1.crc = 1;                
phy1.preamble_len = 8; 
phy2 = LoRaPHY(Fc, SF_2, BW_2, Fs);
phy2.has_header = 1;         
phy2.cr = 4;                 
phy2.crc = 1;                
phy2.preamble_len = 8;
phy3 = LoRaPHY(Fc, SF_3, BW_3, Fs);
phy3.has_header = 1;         
phy3.cr = 4;                 
phy3.crc = 1;                
phy3.preamble_len = 8;

symbols1 = phy1.encode((1:10)');
symbols2 = phy2.encode((1:30)');
symbols3 = phy3.encode((1:5)');

sig1 = phy1.modulate(symbols1);
sig2 = phy2.modulate(symbols2);
sig3 = phy3.modulate(symbols3);


tt1 = (1:length(sig1))/Fs;
tt1 = tt1';
sig11 = sig1 .* exp(-1j * 2*pi * (BW_2) * tt1);
sig12 = sig1 .* exp(1j * 2*pi * (BW_1) * tt1);

tt2 = (1:length(sig2))/Fs;
tt2 = tt2';
sig21 = sig2 .* exp(-1j * 2*pi * (BW_2*3) * tt2);
sig22 = sig2 .* exp(-1j * 2*pi * (-BW_2*2.5) * tt2);
sig23 = sig2 .* exp(-1j * 2*pi * (-BW_2*0.3) * tt2);
sig2 = sig2 + sig21 + sig23;

sig = arr1_add_arr2(sig2, sig11);
sig = arr1_add_arr2(sig, sig12);

sig = [zeros(20000,1); sig];
sig = awgn(sig,0,'measured');

figure;
plot_timefrequency(sig, Fs, SF_1, BW_1);
