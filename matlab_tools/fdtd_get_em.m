% 导入 fdtd 保存的 .mat
% EM_data = fdtd_get_em;
% EM_data = fdtd_get_em(name, path);
function EM_data = fdtd_get_em(varargin)

if nargin == 0
    [name, path] = my_uigetfile('fdtd_em_ans',...
        {'*.mat', 'FDTD EM data'},...
        'Choose EM data');
    if name == 0
        fprintf(2, '** no import data\n');
        return
    end
else
    name = varargin{1};
    path = varargin{2};
end
load(fullfile(path, name));
x = E.x';
y = E.y';
z = E.z';

if length(x) == 1
    Ex = zeros(length(z), length(y));
    Ey = zeros(length(z), length(y));
    Ez = zeros(length(z), length(y));
    idx = 0;
    % 顺序验证过
    for r = 1:length(z)
        for c = 1:length(y)
            idx = idx + 1;
            Ex(r, c) = E.E(idx, 1);
            Ey(r, c) = E.E(idx, 2);
            Ez(r, c) = E.E(idx, 3);
        end
    end
elseif length(y) == 1
    Ex = zeros(length(z), length(x));
    Ey = zeros(length(z), length(x));
    Ez = zeros(length(z), length(x));
    idx = 0;
    % 顺序验证过
    for r = 1:length(z)
        for c = 1:length(x)
            idx = idx + 1;
            Ex(r, c) = E.E(idx, 1);
            Ey(r, c) = E.E(idx, 2);
            Ez(r, c) = E.E(idx, 3);
        end
    end
    
elseif length(z) == 1
    Ex = zeros(length(y), length(x));
    Ey = zeros(length(y), length(x));
    Ez = zeros(length(y), length(x));
    idx = 0;
    % 顺序验证过
    for r = 1:length(y)
        for c = 1:length(x)
            idx = idx + 1;
            Ex(r, c) = E.E(idx, 1);
            Ey(r, c) = E.E(idx, 2);
            Ez(r, c) = E.E(idx, 3);
        end
    end
end

EM_data.x = x;
EM_data.y = y;
EM_data.z = z;
EM_data.Ex = Ex;
EM_data.Ey = Ey;
EM_data.Ez = Ez;

end