function y = threed2twod(x)

    % 提取三维数组的第一维和第三维
    [m, n, p] = size(x); 
    y = zeros(m,p);
    for i = 1:p
        tmp = x(:,:,i);
        y(:,i) = tmp(:,1);
    end
end