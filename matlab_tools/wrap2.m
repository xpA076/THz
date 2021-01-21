% 将周期性数据(如 相位)wrap到[a b)之间, 默认为[-pi pi]
% type: 'l'/'left' for [min, max)
%       'r'/'right' for (min, max]

% ans = wrap2(data)
% ans = wrap2(data, [min max])
% ans = wrap2(data, {min_mat, max_mat}, 'type')

function ret = wrap2(varargin)
narginchk(1,3);
src = varargin{1};
min_ = -pi;
max_ = pi;
type = 'l';

if nargin >= 2
    maxmin = varargin{2};
    if isa(maxmin, 'cell')
        min_ = maxmin{1};
        max_ = maxmin{2};
    else
        min_ = maxmin(1);
        max_ = maxmin(2);
    end        
end 
    
if nargin >= 3
    typ_ = varargin{3};
    type = typ_(1);
end

if type == 'l'
    ret = src - floor((src - min_) ./ (max_ - min_)) .* (max_ - min_);
else
    ret = src - ceil((src - max_) ./ (max_ - min_)) .* (max_ - min_);
end

end
