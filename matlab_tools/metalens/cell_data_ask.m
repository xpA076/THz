function data = cell_data_ask(model)

%% load
[d,t] = comsol2data;
data.d = d(:,2:end);
data.xprams = d(:,1);
data.f = data.xprams;

ex = d(:,2:2:end);
ey = d(:,3:2:end);

data.ex = ex;
data.ey = ey;

%% proc_data
data = metalens_proc_cell_data(data, model, 'circ');

end
