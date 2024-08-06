function y = arr1_add_arr2(arr1, arr2)
    
    len1 = length(arr1);
    len2 = length(arr2);
    maxLength = max(len1, len2);
    
    % 在较短的数组末尾填充零
    if len1 < maxLength
        arr1(len1+1:maxLength) = 0;
    end
    if len2 < maxLength
        arr2(len2+1:maxLength) = 0;
    end
    
    % 进行数组相加
    y = arr1 + arr2;
end