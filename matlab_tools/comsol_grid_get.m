function grid_data = comsol_grid_get(varargin)
% ���� COMSOL ����糡����
[name, path] = my_uigetfile({'*.csv', 'COMSOL grid data'},...
    'COMSOL grid data');
if name == 0
    fprintf(2, '** no import data\n');
    return
end
fprintf('-- reading grid data ...')
fprintf(['-- ', name, '\n']);
fid = fopen(fullfile(name, path));







end