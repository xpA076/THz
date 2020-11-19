function data = cell_data(model)

area = model.area;
h1 = model.h1;
h2 = model.h2;
n2 = model.n2;

load_const;
%% load
[d,t] = comsol_table_get;
data.d = d(:,2:end);
data.f = d(:,1);
ex = d(:,2:end);
sConst = calcSConst(n2.^2, area);
data.sConst = sConst;
data.sx = sConst*ex;
%% phase
k0 = 2*pi*data.f/c_const;
k2 = n2.*k0;
phi0 = k0*h1 + k2*h2;

%% 结构相位信息
data.px = wrap2( -angle(ex) - phi0, [-pi pi]);


end
