% 将 CSRR 转角数据导出为txt, 供 kLayout 宏调用
% klayout_save_rot(rot_d)
% klayout_save_rot(rot_d, name, path)
function ret = klayout_save_rot(varargin)
%% argin
narginchk(1, 3);
rot_d = varargin{1};
r = [21 10;17 14];
if isfield(rot_d, 'r')
    r = rot_d.r;
end
%% uiputfile
if nargin == 1
    [name, path] = my_uiputfile('klayout_src',...
        {'*.txt', 'kLayout CSRR parameters'},...
        'Save kLayout parameters');
    if name == 0
        fprintf(2, '** no save data\n');
        return
    end
else
    name = varargin{2};
    path = varargin{3};
end

%% write file
if isfield(rot_d, 'rot1')
    prefix = name(1:end - 4);
    fullpath = fullfile(path, [prefix, '_rot1.txt']);
    fprintf(['-- writing file : ', prefix, '_rot1.txt\n']);
    fid = fopen(fullpath, 'w+');
    for xi = 1:length(rot_d.x)
        for yi = 1:length(rot_d.y)
            line = [num2str(rot_d.x(xi) * 1e6), ',',...
                num2str(rot_d.y(yi) * 1e6), ',',...
                num2str(r(1, 1)), ',',...
                num2str(r(1, 2)), ',',...
                num2str(rot_d.rot1(yi, xi))];
            fprintf(fid, '%s\n', line);
        end
    end
    fclose(fid);
end
if isfield(rot_d, 'rot2')
    prefix = name(1:end - 4);
    fullpath = fullfile(path, [prefix, '_rot2.txt']);
    fprintf(['-- writing file : ', prefix, '_rot2.txt\n']);
    fid = fopen(fullpath, 'w+');
    for xi = 1:length(rot_d.x)
        for yi = 1:length(rot_d.y)
            line = [num2str(rot_d.x(xi) * 1e6), ',',...
                num2str(rot_d.y(yi) * 1e6), ',',...
                num2str(r(2, 1)), ',',...
                num2str(r(2, 2)), ',',...
                num2str(rot_d.rot2(yi, xi))];
            fprintf(fid, '%s\n', line);
        end
    end
    fclose(fid);
end

end