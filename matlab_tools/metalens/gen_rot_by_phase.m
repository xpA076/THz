% 生成 rot 矩阵
% 因为默认是对 RCP->LCP 相位变化
% 所以转角和相位关系之间有负号
% rot = gen_rot(phase)
% rot = gen_rot(phase, rot_1)

function rot = gen_rot_by_phase(varargin)
phase = varargin{1};
rot = ceil(wrap2((-phase / 2) / pi * 180, [0 360], 'r') / 5) * 5;
rot = wrap2(rot + 45, [0 360], 'r');
if nargin > 1
    rot1 = varargin{2};
    rot = wrap2(wrap2(rot, {rot1 + 90, rot1 + 270}), [0 360], 'r');
end


end