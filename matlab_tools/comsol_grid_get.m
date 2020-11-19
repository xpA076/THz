% 导入 COMSOL 网格电场数据
function grid_data = comsol_grid_get(varargin)
%% uigetfile
[name, path] = my_uigetfile({'*.csv', 'COMSOL grid data'},...
    'COMSOL grid data');
if name == 0
    fprintf(2, '** no import data\n');
    return
end
fprintf('-- reading grid data ...\n')
fprintf(['--  ' name '\n']);
%% read *.csv strings
fid = fopen(fullfile(path, name));
raw_str = [];
while ~feof(fid)
    cur_line = string(fgetl(fid));
    raw_str = [raw_str; cur_line];
end
fclose(fid);
%% process strings
fprintf('-- processing strings ...\n')
ps = 1; % pointer of strings
% 确定 "% Grid ***" 所在行
while length(strfind(raw_str(ps), 'Grid')) == 0
    ps = ps + 1;
end
x_str = raw_str(ps + 1);
y_str = raw_str(ps + 2);
ps = ps + 3;
% 确定 "% Data" 所在行
ex_str = [];
ey_str = [];
while length(strfind(raw_str(ps), 'Data')) == 0
    ps = ps + 1;
end
% 添加 ex data 字符串
for ps = (ps + 1):length(raw_str)
    if length(strfind(raw_str(ps), 'Data')) > 0
        break
    end
    fd = strfind(raw_str(ps), '%');
    if length(fd) > 0 && fd(1) == 1
        continue
    end
    ex_str = [ex_str; raw_str(ps)];
end
% 添加 ey data 字符串
for ps = (ps + 1):length(raw_str)
    if length(strfind(raw_str(ps), 'Data')) > 0
        break
    end
    fd = strfind(raw_str(ps), '%');
    if length(fd) > 0 && fd(1) == 1
        continue
    end
    ey_str = [ey_str; raw_str(ps)];
end
%% convert strings to data
fprintf('-- converting data ...\n')
% x, y data
x_str_split = regexp(x_str, ',', 'split');
y_str_split = regexp(y_str, ',', 'split');
x = zeros(1, length(x_str_split));
y = zeros(1, length(y_str_split));
for i = 1:length(x)
    x(i) = str2num(x_str_split{1, i});
end
for i = 1:length(y)
    y(i) = str2num(y_str_split{1, i});
end
% ex, ey data
Ex = zeros(length(y), length(x));
Ey = zeros(length(y), length(x));
for r = 1:length(y)
    row_split = regexp(ex_str(r), ',', 'split');
    for c = 1:length(x)
        Ex(r, c) = str2num(row_split{1, c});
    end
end
for r = 1:length(y)
    row_split = regexp(ey_str(r), ',', 'split');
    for c = 1:length(x)
        Ey(r, c) = str2num(row_split{1, c});
    end
end
fprintf('-- comsol_grid_get.m finished\n')
%% return
grid_data.x = x;
grid_data.y = y;
grid_data.Ex = Ex;
grid_data.Ey = Ey;

end















