function iq_values = f_read(filename)
    %读入文件
    f = fopen(filename, 'rb');
    values = fread(f, [2, Inf], 'float');
    fclose(f);
    iq_values = values(1, :) + values(2, :) * 1i;
    [r, c] = size (iq_values);
    iq_values = reshape (iq_values, c, r);
end
