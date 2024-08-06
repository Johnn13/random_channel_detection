function y = chirp(is_up, sf, bw, fs, h, cfo, tdelta, tscale)
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
        N = 2^sf;
        T = N/bw;
        samp_per_sym = round(fs/bw*N);
        h_orig = h;
        h = round(h);
        cfo = cfo + (h_orig - h) / N * bw;
        if is_up
            k = bw/T;
            f0 = -bw/2+cfo;
        else
            k = -bw/T;
            f0 = bw/2+cfo;
        end

        % retain last element to calculate phase
        t = (0:samp_per_sym*(N-h)/N)/fs*tscale + tdelta;
        snum = length(t);
        c1 = exp(1j*2*pi*(t.*(f0+k*T*h/N+0.5*k*t)));

        if snum == 0
            phi = 0;
        else
            phi = angle(c1(snum));
        end
        t = (0:samp_per_sym*h/N-1)/fs + tdelta;
        c2 = exp(1j*(phi + 2*pi*(t.*(f0+0.5*k*t))));

        y = cat(2, c1(1:snum-1), c2).';
    end