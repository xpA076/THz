% 将 wrap 到[a b]之间的数据按列 unwrap 为连续数据, 默认区间为[-pi pi]
function ret = unwrap4(varargin)
narginchk(1,2);
src = varargin{1};
vec = [-pi pi];
if (nargin > 1)
    vec = varargin{2};
end

r = size(src, 1);
c = size(src, 2);

ret = zeros(r, c);

a = min(vec);
b = max(vec);
t = b - a;

for ci = 1:c
    ret(1, ci) = src(1, ci);
    for i = 2 : r
        minlim = ret(i - 1, ci) - t /2 ;
        ret(i, ci) = src(i, ci) - floor((src(i, ci) -  minlim) / t) * t;
    end
end

end