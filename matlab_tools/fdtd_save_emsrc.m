function ret = fdtd_save_emsrc(varargin)
% ret = fdtd_save_emsrc(EM_data)
% ret = fdtd_save_emsrc(EM_data, name, path)

EM_data = varargin{1};
%% uiputfile
if nargin == 1
    [name, path] = my_uiputfile({'*.mat', 'FDTD EM_src field'}, 'Save EM_src');
    if name == 0
        fprintf(2, '** no save data\n');
        return
    end
else
    name = varargin{2};
    path = varargin{3};
end
%% data
load_const;
EM.x = EM_data.x;
EM.y = EM_data.y;
EM.z = 0;

lenx = length(EM.x);
leny = length(EM.y);

E = zeros(lenx * leny, 3);
H = zeros(lenx * leny, 3);

idx = 0;
bar = waitbar(0, '');
set(bar, 'name', 'Reshaping');

% x, y Ë³Ðò
for xc = 1:lenx
    for yc = 1:leny
        idx = idx + 1;
        E(idx, 1) = EM_data.Ex(xc, yc);
        E(idx, 2) = EM_data.Ey(xc, yc);
    end
    waitbar(yc / leny, bar, [num2str(yc) '/' num2str(leny)]);
end
close(bar)
H(:, 1) = -(eps0/mu0)^0.5 * E(:, 2);
H(:, 2) = (eps0/mu0)^0.5 * E(:, 1);

EM.E = E;
EM.H = H;


%% save *.mat
EM.Lumerical_dataset = fdtd_gen_addition();
save(fullfile(path, name), 'EM');


end

function Lumerical_dataset = fdtd_gen_addition()
attr1.variable = 'E';
attr1.name = 'E';
attr2.variable = 'H';
attr2.name = 'H';
attrs = [attr1; attr2];
Lumerical_dataset.attributes = attrs;
Lumerical_dataset.geometry = 'rectilinear';
end
