% ���� rot ����
% ��ΪĬ���Ƕ� RCP->LCP ��λ�仯
% ����ת�Ǻ���λ��ϵ֮���и���
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