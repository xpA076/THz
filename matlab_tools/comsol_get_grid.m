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
% fid = fopen(fullfile(path, name));
% raw_str = [];
% idx_grid = 0;
% idx_data = [];
% idx_line = 0;
% while ~feof(fid)
%     idx_line = idx_line + 1;
%     cur_line = string(fgetl(fid));
%     raw_str = [raw_str; cur_line];
%     if length(strfind(cur_line, 'Grid')) > 0
%         idx_grid = idx_line;
%     end
%     if length(strfind(cur_line, 'Data')) > 0
%         idx_data = [idx_data; idx_line];
%     end
% end
% fclose(fid);

raw_str = readlines(name, path);
idx_grid = 0;
idx_data = [];
for idx_line = 1:length(raw_str)
    cur_line = raw_str(idx_line);
    if length(strfind(cur_line, 'Grid')) > 0
        idx_grid = idx_line;
    end
    if length(strfind(cur_line, 'Data')) > 0
        idx_data = [idx_data; idx_line];
    end
    % ignore lines after '%%%'
    if length(strfind(cur_line, '%%%')) > 0
        raw_str = raw_str(1:idx_line - 1);
        break;
    end
end

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


bar = my_waitbar.bars.get_by_name('comsol_get_grid');
set(bar, 'type', 'count', 'title', 'Converting data ...',...
    'total', size(bound, 1));
bar.update(0);

for grid_idx = 1:size(bound, 1)
    bar.update(grid_idx);
    d_tmp = zeros(length(y), length(x));
    for str_row_idx = bound(grid_idx, 1) + 2:bound(grid_idx, 2)
        bar1 = my_waitbar.bars.get_by_name('comsol_get_grid_for');
        set(bar1, 'type', 'count', 'title', 'Read lines ...',...
            'total', bound(grid_idx, 2) - (bound(grid_idx, 1) + 1));

        
        str = raw_str(str_row_idx);
        % check empty string
        if strlength(str) == 0
            continue
        end
        % check comment
        fd = strfind(str, '%');
        if length(fd) > 0 && fd(1) == 1
            continue
        end
        r = str_row_idx - (bound(grid_idx, 1) + 2) + 1;
        % string process
        row_split = regexp(str, ',', 'split');
        for c = 1:length(x)
            % comsol 导入的数据要取复共轭
            d_tmp(r, c) = conj(str2num(row_split{1, c}));
        end
        
        bar1.update(str_row_idx - (bound(grid_idx, 1) + 2));
    end
    gd.x = x;
    gd.y = y;
    gd.title = raw_str(bound(grid_idx, 1) + 1);
    gd.data = d_tmp;
    grid_data = [grid_data; gd];
end


end



