% 保存 COMSOL 网格数据
% comsol_save_grid(x, y, data)
% comsol_save_grid(x, y, data, name, path)
function ret = comsol_save_grid(varargin)
%% argin
narginchk(3,5);
x = varargin{1};
y = varargin{2};
data = varargin{3};

%% uiputfile
if nargin == 3
    [name, path] = my_uiputfile({'*.csv', 'COMSOL grid data'},...
        'Save COMSOL grid data');
    if name == 0
        fprintf(2, '** no save data\n');
        return
    end
else
    name = varargin{4};
    path = varargin{5};
end

%% write file
fullpath = fullfile(path, name);
fprintf(['-- path : ', replace(path, '\', '\\'), '\n'])
fprintf(['-- writing file : ', name, '\n']);
fid = fopen(fullpath, 'w+');
fprintf(fid, '%s\n', '% Grid');
fprintf(fid, concat_vector(x));
fprintf(fid, concat_vector(y));
fprintf(fid, '%s\n', '% Data');
for i = 1:size(data, 1)
    fprintf(fid, concat_vector(data(i, :)));
end
fclose(fid);
fprintf('-- write file finished\n');
end



function str = concat_vector(vec)
str = '';
for i = 1:length(vec) - 1
    str = [str, num2str(vec(i)), ','];
end
str = [str, num2str(vec(length(vec))), '\n'];
end



