% ������������(�� ��λ)wrap��[a b)֮��, Ĭ��Ϊ[-pi pi]
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