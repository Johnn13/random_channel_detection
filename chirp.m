function y = chirp(is_up,SF,BW,Fs,h,cfo,tdelta,tscale)
    % chirp  Generate a LoRa chirp symbol
    %
    % input:
    %     is_up: `true` if constructing an up-chirp
    %            `false` if constructing a down-chirp
    %     sf: Spreading Factor
    %     bw: Bandwidth
    %     fs: Sampling Frequency
    %     h: Start frequency offset (0 to 2^SF-1)
    %     cfo: Carrier Frequency Offset
    %     tdelta: Time offset (0 to 1/fs)
    %     tscale: Scaling the sampling frequency
    % output:
    %     y: Generated LoRa symbol
    if nargin < 8
        tscale = 1;
    end
    if nargin < 7
        tdelta = 0;
    end
    if nargin < 6
        cfo = 0;
    end
    N = 2^SF;
    T = N/BW;
    sample_per_symbol = round(Fs * T);
    h_orig = h;
    h = round(h);
    cfo = cfo + (h_orig - h) * BW / N;
    
    if is_up
        k = BW/T;
        f0 = -BW/2 + cfo;
    else
        k = -BW/T;
        f0 = BW/2 + cfo;
    end
    t1 = (0:sample_per_symbol*(N-h)/N)/Fs*tscale + tdelta; % first segment chirp
    snum = length(t1);
    c1 = exp(1j*2*pi*(t1.*(f0 + BW*h/N + k/2*t1)));
    if snum == 0
        phi = 0;
    else 
        phi = angle(c1(snum));
    end
    t2 = (0:sample_per_symbol*h/N-1)/Fs*tscale + tdelta; % second segment chirp
    c2 = exp(1j*(phi + 2*pi*(t2.*(f0 + k/2*t2))));
    
    y = cat(2,c1(1:snum-1),c2).';
end