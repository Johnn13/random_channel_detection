function v = array_diff(x1, x2)
    % 模糊比较数组 x1 和 x2
    lx1 = length(x1);
    lx2 = length(x2);

    if lx1 == lx2 
        v = x1 - x2;
    end
   
    % 如果x1较长，取其中间元素
    if lx1 > lx2
        ld = lx1 - lx2;
        d1 = x1(1:end-ld) - x2;
        d2 = x1(1+ld:end) - x2;
        v = min(abs(d1),abs(d2));
    % 如果x2较长，取其中间元素
    elseif lx2 > lx1
        ld = lx2 - lx1;
        d1 = x2(1:end-ld) - x1;
        d2 = x2(1+ld:end) - x1;
        v = min(abs(d1),abs(d2));
    end
end


