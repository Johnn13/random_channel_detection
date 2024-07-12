Fs = 1e6;
BW = 500e3;
SF = 7;
N = 2^(SF);
Ts = N/BW;
nsamp = Ts* Fs;
% t = (1:nsamp)/Fs;
k = BW/Ts;
h = 10;

t1 = (0:nsamp*(N-h)/N)/Fs; % 
t1 = t1';
t2 = (0:nsamp*h)/N/Fs; % 
t2 = t2';
snum = length(t1);
f0 = -BW/2;
c1 = exp(1j*2*pi*(t1*(f0 + BW/N + k/2*t1)));
c2 = exp(1j*(2*pi*(t2.*(f0 + k/2*t2))));
y = cat(2,c1(1:snum-1),c2).';


%%
close all
clear all
clc 
SF = 7;
BW = 250e3;
Fs = 1e6;
h = 30;

N = 2^SF;
T = N/BW;
sample_per_symbol = round(Fs * T);

dc = chirp(false,SF,BW,Fs,0);
k = BW/T;
t1 = (0:sample_per_symbol*(N-h)/N)/Fs; % first segment chirp
snum = length(t1);
c1 = exp(1j*2*pi*(t1.*(-BW/2 + BW*h/N + k/2*t1)));
if snum == 0
    phi = 0;
else 
    phi = angle(c1(snum));
end
t2 = (0:sample_per_symbol*h/N-1)/Fs; % second segment chirp
c2 = exp(1j*(phi + 2*pi*(t2.*(-BW/2 + k/2*t2))));
y1 = cat(2,c1(1:snum-1),c2).';
figure;
plot_timefrequency(y1,Fs,SF,BW);
figure;
plot(real(y1),'LineWidth', 1.5);

t = [t1(1:snum-1) t2];
% c3 = cos(t1.*c1);
% c4 = cos(t2.*c2);
% c3 = cos(c1);
% c4 = cos(c2);
c3 = cos(h*t1) .* real(c1);
c4 = cos(h*t2) .* real(c2);
% c3 = exp(1j*2*pi*(c1));
% c4 = exp(1j*2*pi*(c2));
% c3 = exp(1j*2*pi*(t1.*c1));
% c4 = exp(1j*2*pi*(t2.*c2));
y2 = cat(2,c3(1:snum-1),c4).';
figure;
plot_timefrequency(y2,Fs,SF,BW);
figure;
plot(y2,'LineWidth', 1.5);
title('y2信号及其包络');
% 对 y2 做 FFT
y2_fft = fft(y2);
figure;
plot(abs(y2_fft));
y2_fft_d = y2_fft .* dc;
figure;
plot(abs(y2_fft_d));

%% 如果是链接在一起的

y3 = cos(t').* abs(y1);
figure;
plot_timefrequency(y3,Fs,SF,BW);
title('y3信号及其包络');
figure;
plot(y3,'LineWidth', 1.5);
% 对 y3 做 FFT
y3_fft = fft(y3);
figure;
plot(abs(y3_fft));

%% 画出包络

% 使用Hilbert变换计算包络
a_y2 = hilbert(y2);
e_y2 = abs(a_y2);

% 绘制原始信号和包络

figure;
plot(t, y2, 'b', 'DisplayName', '原始信号');
hold on;
plot(t, e_y2, 'r', 'LineWidth', 1.5, 'DisplayName', '包络');
hold off;
xlabel('时间 (秒)');
ylabel('幅度');
title('信号及其包络');
legend;
grid on;

% 求出包络的频率
e_y2_fft = fft(e_y2);
figure;
plot(abs(e_y2_fft));
title('y2信号包络的频谱图');
