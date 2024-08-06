function v = f_write(data, filename)

    % usage: write(data, filename)
    %
    %  open filename and write data to it
    %  Format is interleaved float IQ e.g. each
    %  I,Q 32-bit float IQIQIQ....
    %  This is compatible with read_complex_binary()
    %

    m = nargchk (2,2,nargin);
    if (m)
    usage (m);
    end

    f = fopen (filename, 'wb');
    if (f < 0)
    v = 0;
    else
    re = real(data);
    im = imag(data);
    re = re(:)';
    im = im(:)';
    y = [re;im];
    y = y(:);
    v = fwrite (f, y, 'float');
    fclose (f);
end