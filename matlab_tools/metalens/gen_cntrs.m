% 生成中心坐标网格
function [X, Y] = gen_cntrs(p, count)
countx = count(1);
if length(count > 1)
    county = count(2);
else
    county = countx;
end

cntrxmin = -p * countx / 2 + p / 2;
cntrxmax = -cntrxmin;
cntrymin = -p * county / 2 + p / 2;
cntrymax = -cntrymin;

x_cntrs = linspace(cntrxmin, cntrxmax, countx);
y_cntrs = linspace(cntrymin, cntrymax, county);
[X, Y] = meshgrid(x_cntrs, y_cntrs);

end