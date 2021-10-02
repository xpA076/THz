function data = metalens_proc_cell_data(data_in, model, type)
%_PROC_CELL_DATA Summary of this function goes here
%   sx, sy, slcp, srcp 为 E=E0*exp[i(kz-wt)] 方程下的透射参数



%% constants
load_const;
area = model.area;
h1 = model.h1;
h2 = model.h2;
n1 = model.n1;
n2 = model.n2;

data = data_in;
ex = data_in.ex;
ey = data_in.ey;

sconst = calc_sconst(n2.^2, area);
data.sconst = sconst;

% srcp = conj(2^-0.5 * sconst .* (ex-1i*ey));
% slcp = conj(2^-0.5 * sconst .* (ex+1i*ey));
% 
% data.sx = conj(sconst .* ex);
% data.sy = conj(sconst .* ey);

srcp = (2^-0.5 * sconst .* (ex + 1i*ey));
slcp = (2^-0.5 * sconst .* (ex - 1i*ey));

data.sx = (sconst .* ex);
data.sy = (sconst .* ey);

data.srcp = srcp;
data.slcp = slcp;
data.trcp = abs(srcp);
data.tlcp = abs(slcp);

%% phase
k1 = n1 .* 2*pi*data.f/c_const;
k2 = n2 .* k1/n1;
phi0 = k1.*h1 + k2.*h2;


%% 结构相位信息 (phase profile)
data.prcp = wrap2( angle(srcp) - phi0, [-pi pi]);
data.plcp = wrap2( angle(slcp) - phi0, [-pi pi]);
data.px = wrap2( angle(ex) - phi0, [-pi pi]);
data.py = wrap2( angle(ey) - phi0, [-pi pi]);

end

