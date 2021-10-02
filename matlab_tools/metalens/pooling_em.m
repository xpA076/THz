function EM_data = pooling_em(EM_src, ratio)
%% chaeck ratio
if mod(length(EM_src.x), ratio) > 0
    error('** bad ratio');
    return
end
%% matrix size
lenx = length(EM_src.x) / ratio;
leny = length(EM_src.y) / ratio;
x_new = zeros(1, lenx);
y_new = zeros(1, leny);
Ex_new = zeros(leny, lenx);
Ey_new = zeros(leny, lenx);
%% sub-sampling x,y
for xi = 1:lenx
    x_vec = EM_src.x(((xi - 1) * ratio + 1):(xi * ratio));
    x_new(xi) = sum(x_vec, 'all') / ratio;
end
for yi = 1:leny
    y_vec = EM_src.y((yi - 1) * ratio + 1:yi * ratio);
    y_new(yi) = sum(y_vec, 'all') / ratio;
end
%% sub-sampling Ex, Ey
for xi = 1:lenx
    for yi = 1:leny
        mat = EM_src.Ex((yi - 1) * ratio + 1:yi * ratio, ...
            (xi - 1) * ratio + 1:xi * ratio);
        Ex_new(yi, xi) = sum(mat, 'all') / ratio^2;
        mat = EM_src.Ey((yi - 1) * ratio + 1:yi * ratio, ...
            (xi - 1) * ratio + 1:xi * ratio);
        Ey_new(yi, xi) = sum(mat, 'all') / ratio^2;
    end
end
%% return
EM_data.x = x_new;
EM_data.y = y_new;
EM_data.Ex = Ex_new;
EM_data.Ey = Ey_new;

end


