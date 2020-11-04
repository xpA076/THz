% �� wrap ��[a b]֮������ݰ��� unwrap Ϊ��������, Ĭ������Ϊ[-pi pi]
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