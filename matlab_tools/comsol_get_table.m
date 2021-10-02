% comsol 导出表格数据 转换成 复数矩阵 data
% *** 在 comsol 导出文件读取数据时 ***
%     *** 已转为原数据复共轭 ***
% [data, title] = comsol_get_table;
% [data, title] = comsol_get_table(str_array);
% [data, title] = comsol_get_table(name, path);
function [data, titles] = comsol_get_table(varargin)
%% argin
if nargin == 0
    % uigetfile
    [name, path] = my_uigetfile('comsol_table',...
        {'*.csv','.csv for COMSOL';'*.txt','.txt for COMSOL'},...
        'COMSOL table data');
    if name == 0
        error( '** no import data\n');
        return
    end
end
if nargin == 2
    name = varargin{1};
    path = varargin{2};
end
if nargin == 1
    str_array = varargin{1};
else
    str_array = readlines(name, path);
end

%% csv 文件处理
titles = csv_split(str_array(5));

% build data_str
data_str = [];
for r = 6:length(str_array)
    str = str_array(r);
    % check empty string
    if strlength(str) == 0
        continue
    end
    % check comment
    fd = strfind(str, '%');
    if length(fd) > 0 && fd(1) == 1
        continue
    end
    data_str = [data_str; str];
end
% proc_data
data = zeros(length(data_str), length(titles));
for r = 1:length(data_str)
    str_split = regexp(data_str(r), ',', 'split');
    for c = 1:length(titles)
        data(r, c) = conj(str2num(str_split{1, c}));
    end
end

if nargin > 0
    return
end
for i = 1:length(titles)
    fprintf(['col-', num2str(i, '%02d'), ': ']);
    fprintf('%s\n', char(titles(i)));
end

end

function parts = csv_split(s)
splits = regexp(s, '"', 'split');
parts = [];
for i = 1:length(splits)
    if mod(i, 2) == 0
        % 引号内的内容为一整体
        parts = [parts, string(splits{1, i})];
    else
        % 非引号内内容以逗号','分割
        part_spl = regexp(splits{1, i}, ',', 'split');
        for pi = 1:length(part_spl)
            part_spl_str = string(part_spl{1, pi});
            % 去除空白字符串
            if strlength(part_spl_str) == 0
                continue
            end
            if part_spl_str == " "
                continue
            end
            % 添加合法字符串
            parts = [parts, part_spl_str];
        end
    end        
end

end













    