% 对列求数值微分，输入一个列向量 x 和一个矩阵 y
% 若只输入一个矩阵，则第一列为 x

function drv = num_drv(varargin)
narginchk(1,2);
x = [];
y = [];
if (nargin == 1)
    mat = varargin{1};
    x = mat(:,1);
    y = mat(:,2:end);
elseif (nargin == 2)
    x = varargin{1};
    y = varargin{2};
end
r = size(y, 1);
c = size(y, 2);
drv = zeros(r, c);
drv(1, :) = (y(2, :) - y(1, :)) / (x(2) - x(1));
drv(r, :) = (y(r, :) - y(r - 1, :)) / (x(r) - x(r - 1));
for i = 2 : r-1
    drv(i, :) = (y(i + 1, :) - y(i - 1, :)) / (x(i + 1) - x(i - 1));
end

end