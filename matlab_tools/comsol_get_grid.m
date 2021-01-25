% 导入 COMSOL 网格电场数据
% grid_data = comsol_get_grid;
% grid_data = comsol_get_grid(name, path);
function grid_data = comsol_get_grid(varargin)

fprintf(['-- start at : ', datestr(now, 31), '\n']);
%% uigetfile
if nargin == 0
    [name, path] = my_uigetfile('comsol_grid',...
        {'*.csv', 'COMSOL grid data'},...
        'Choose COMSOL grid data');
    if name == 0
        fprintf(2, '** no import data\n');
        return
    end
else
    name = varargin{1};
    path = varargin{2};
end
fprintf('-- reading grid data ...\n')
fprintf(['-->  ' name '\n']);


%% read *.csv strings
fid = fopen(fullfile(path, name));
raw_str = [];
idx_grid = 0;
idx_data = [];
idx_line = 0;
while ~feof(fid)
    idx_line = idx_line + 1;
    cur_line = string(fgetl(fid));
    raw_str = [raw_str; cur_line];
    if length(strfind(cur_line, 'Grid')) > 0
        idx_grid = idx_line;
    end
    if length(strfind(cur_line, 'Data')) > 0
        idx_data = [idx_data; idx_line];
    end
end
fclose(fid);

%% process Grid x,y position data
fprintf('-- processing x,y strings ...\n')
x_str = raw_str(idx_grid + 1);
y_str = raw_str(idx_grid + 2);
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

%% process data strings
grid_data = [];
bound = zeros(length(idx_data), 2);
bound(:, 1) = idx_data;
bound(1:end-1, 2) = idx_data(2:end) - 1;
bound(end, 2) = length(raw_str);
fprintf('-- converting data ...\n')

% bar = waitbar(0, '', 'WindowStyle', 'docked');
bar = my_waitbar.bars.get_by_name('comsol_get_grid');
set(bar, 'type', 'count', 'title', 'Converting data ...',...
    'total', size(bound, 1));
bar.update(0);


for grid_idx = 1:size(bound, 1)
    bar.update(grid_idx);
%     set(bar, 'Name', ...
%         ['Converting: ' num2str(grid_idx) ' / ' num2str(size(bound, 1))]);
    d_tmp = zeros(length(y), length(x));
    for str_row_idx = bound(grid_idx, 1) + 2:bound(grid_idx, 2)
        str = raw_str(str_row_idx);
        r = str_row_idx - (bound(grid_idx, 1) + 2) + 1;
        % check comment
        fd = strfind(str, '%');
        if length(fd) > 0 && fd(1) == 1
            continue
        end
        % string process
        row_split = regexp(str, ',', 'split');
        for c = 1:length(x)
            % comsol 导入的数据要取复共轭
            d_tmp(r, c) = conj(str2num(row_split{1, c}));
        end
        percent = round(r / length(y) * 1000) / 10;
%         waitbar(percent / 100, bar, [num2str(percent) ' %']);
    end
    gd.x = x;
    gd.y = y;
    gd.title = raw_str(bound(grid_idx, 1) + 1);
    gd.data = d_tmp;
    grid_data = [grid_data; gd];
end
% close(bar);
% 
% ex_str = [];
% ey_str = [];
% while length(strfind(raw_str(ps), 'Data')) == 0
%     ps = ps + 1;
% end
% % 添加 ex data 字符串
% for ps = (ps + 1):length(raw_str)
%     if length(strfind(raw_str(ps), 'Data')) > 0
%         break
%     end
%     fd = strfind(raw_str(ps), '%');
%     if length(fd) > 0 && fd(1) == 1
%         continue
%     end
%     ex_str = [ex_str; raw_str(ps)];
% end
% % 添加 ey data 字符串
% for ps = (ps + 1):length(raw_str)
%     if length(strfind(raw_str(ps), 'Data')) > 0
%         break
%     end
%     fd = strfind(raw_str(ps), '%');
%     if length(fd) > 0 && fd(1) == 1
%         continue
%     end
%     ey_str = [ey_str; raw_str(ps)];
% end
% %% convert strings to data
% fprintf('-- converting data ...\n')
% % x, y data
% % ex, ey data
% Ex = zeros(length(y), length(x));
% Ey = zeros(length(y), length(x));
% bar = waitbar(0, '');
% for r = 1:length(y)
%     row_split = regexp(ex_str(r), ',', 'split');
%     for c = 1:length(x)
%         Ex(r, c) = str2num(row_split{1, c});
%     end
%     waitbar((r-1)/length(y), bar, 'Converting Ex... ');
% end
% close(bar);
% bar = waitbar(0, '');
% for r = 1:length(y)
%     row_split = regexp(ey_str(r), ',', 'split');
%     for c = 1:length(x)
%         Ey(r, c) = str2num(row_split{1, c});
%     end
%     waitbar((r-1)/length(y), bar, 'Converting Ey... ');
% end
% close(bar);
% fprintf('-- comsol_grid_get.m finished\n')
% %% return
% grid_data.x = x;
% grid_data.y = y;
% grid_data.Ex = conj(Ex);
% grid_data.Ey = conj(Ey);

end



