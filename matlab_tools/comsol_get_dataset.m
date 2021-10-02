function dataset = comsol_get_dataset(varargin)

fprintf(['-- start at : ', datestr(now, 31), '\n']);
%% uigetfile
if nargin == 0
    [name, path] = my_uigetfile('comsol_dataset',...
        {'*.csv', 'COMSOL dataset data'},...
        'Choose COMSOL dataset data');
    if name == 0
        fprintf(2, '** no import data\n');
        return
    end
else
    name = varargin{1};
    path = varargin{2};
end
fprintf('-- reading dataset data ...\n')
fprintf(['-->  ' name '\n']);

%% read *.csv strings
raw_str = readlines(name, path);
col_str = "";
data_strs = [];
for idx_line = 1:length(raw_str)
    cur_line = raw_str(idx_line);
    if length(strfind(cur_line, '% ')) > 0
        col_str = cur_line;
    else
        data_strs = [data_strs;cur_line];
    end
end
x = zeros(length(data_strs),1);
y = zeros(length(data_strs),1);
z = zeros(length(data_strs),1);
data = zeros(length(data_strs), ...
    length(regexp(data_strs(1), ',', 'split')) - 3);

bar = my_waitbar.bars.get_by_name('comsol_get_dataset');
set(bar, 'type', 'count', 'title', 'Reading dataset ...',...
    'total', length(data_strs));
bar.update(0);
for i = 1:length(data_strs)
    data_str_split = regexp(data_strs(i), ',', 'split');
    x(i) = str2num(data_str_split{1, 1});
    y(i) = str2num(data_str_split{1, 2});
    z(i) = str2num(data_str_split{1, 3});
    for di = 1:size(data, 2)
        data(i, di) = str2num(data_str_split{1, di + 3});
    end
    bar.update(i);
end
dataset.x = x;
dataset.y = y;
dataset.z = z;
dataset.data = data;


end
