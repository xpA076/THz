% 将周期性数据(如 相位)wrap到[a b)之间, 默认为[-pi pi]
function ret = wrap2(varargin)
narginchk(1,2);
src = varargin{1};
vec = [-pi pi];
if (nargin > 1)
    vec = varargin{2};
end

ret = src - floor((src - min(vec)) / (max(vec) - min(vec)))...
    * (max(vec) - min(vec));
end