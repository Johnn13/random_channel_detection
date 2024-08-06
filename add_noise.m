function y = add_noise(sig, reqSNR)
   % 该加噪函数参考了 agwn 
    sig_length = numel(sig);
%     sigPower = sum(sig(:) .* conj(sig(:)))/sig_length;
    sigPower = sum(abs(sig(:)).^2)/sig_length;  % linear
    noisePower = sigPower/10^(reqSNR/10);
    fprintf('sig Power:%.8f, noise Power:%.8f\n',sigPower,noisePower);
    
    % 通过 ifft 产生中心频率为0,固定带宽的噪声
    noise = sqrt(noisePower/2) * complex(randn(size(sig)),randn(size(sig)));
    y = noise + sig;
end