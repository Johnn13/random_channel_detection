%%
close all
clear all
clc


% ==== packet common set =====
Fs = 500e3;


% ==== packet1 ==== 
SF1 = 8; 
BW1 = 125e3;
nsamp1 = 2^(SF1) * Fs / BW1;
Fc_offset1 = -125e3/2;
Win_offset1 = 0;

% ==== packet1 ==== 
SF2 = 10; 
BW2 = 250e3;
nsamp2 = 2^(SF2) * Fs / BW2;
Fc_offset2 = 0;
Win_offset2 = 0;


% ==== generate chirp =====

chirp1 = chirp(true,SF1,BW1,Fs,0,0,0,1);
chirp2 = chirp(true,SF2,BW2,Fs,0,0,0,1);

sig1 = repmat(chirp1,2,1);
sig2 = chirp2;
tt = (1:length(sig1))/Fs;
tt = tt';
sig1 = sig1 .* exp(1j * 2*pi * (Fc_offset1) * tt);
sig = sig1 + sig2;

figure;
plot_timefrequency(sig,Fs,SF2,BW2);
figure;
plot(real(sig),'LineWidth', 1.5);

% ==== dechirp =====

dchirp2 = conj(chirp2);
sig_d = sig .* dchirp2;
fft_res = fft(sig_d);
figure;
plot(abs(fft_res));