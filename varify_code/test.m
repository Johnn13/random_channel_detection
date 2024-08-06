clc
close all
clear all
addpath("../");


%%  Loading File
path = '../../../sig/ideal_sig/test/';
fil_nm = 'sf12_bw500k_freq915_cr48.cfile'
filename = [path fil_nm];
x_1 = f_read(filename);


% radio variables
Fs = 1e6;
Fc = 915e6;
SF = 12;
BW = 500e3;


phy = LoRaPHY(Fc, SF, BW, Fs);
[symbols_d, cfo, netid] = phy.demodulate(x_1);
fprintf("[demodulate] symbols:\n");
disp(symbols_d);