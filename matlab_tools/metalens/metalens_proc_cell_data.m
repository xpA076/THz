function data = metalens_proc_cell_data(data_in, model, type)
%_PROC_CELL_DATA Summary of this function goes here
%   Detailed explanation goes here

%% constants
load_const;
area = model.area;
h1 = model.h1;
h2 = model.h2;
n2 = model.n2;

data = data_in;
ex = data_in.ex;
ey = data_in.ey;

sconst = calc_sconst(n2.^2, area);
srcp = 2^-0.5*(ex-1i*ey).*sconst;
slcp = 2^-0.5*(ex+1i*ey).*sconst;

data.sconst = sconst;
data.sx = sconst*ex;
data.sy = sconst*ey;

data.srcp = srcp;
data.slcp = slcp;
data.trcp = abs(srcp);
data.tlcp = abs(slcp);

%% phase
k0 = 2*pi*data.f/c_const;
k2 = n2.*k0;
phi0 = k0*h1 + k2*h2;


%% 结构相位信息
data.prcp = wrap2( -angle(srcp) - phi0, [-pi pi]);
data.plcp = wrap2( -angle(slcp) - phi0, [-pi pi]);
data.px = wrap2( -angle(ex) - phi0, [-pi pi]);
data.py = wrap2( -angle(ey) - phi0, [-pi pi]);


end

