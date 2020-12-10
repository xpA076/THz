function ret = comsol_save_grid_emsrc(EM_data)

[name, path] = my_uiputfile({'*.csv', 'COMSOL EM data'},...
    'Save COMSOL EM_src data');
prefix = name(1:length(name) - 4);

% fprintf('-- generating abs(Ex) ...\n');
comsol_save_grid(EM_data.x, EM_data.y, abs(EM_data.Ex), ...
    [prefix '_absEx.csv'], path);

% fprintf('-- generating angle(Ex) ...\n');
comsol_save_grid(EM_data.x, EM_data.y, angle(conj(EM_data.Ex)), ...
    [prefix '_angEx.csv'], path);

% fprintf('-- generating abs(Ey) ...\n');
comsol_save_grid(EM_data.x, EM_data.y, abs(EM_data.Ey), ...
    [prefix '_absEy.csv'], path);

% fprintf('-- generating angle(Ey) ...\n');
comsol_save_grid(EM_data.x, EM_data.y, angle(conj(EM_data.Ey)), ...
    [prefix '_angEy.csv'], path);

% fprintf('-- generate file finished\n');

end