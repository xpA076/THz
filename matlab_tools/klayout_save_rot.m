% 将 CSRR 转角数据导出为txt, 供 kLayout 宏调用
% klayout_save_rot(rot_d, code)
% (not supported) klayout_save_rot(rot_d, name, path)
function ret = klayout_save_rot(varargin)
%% argin
narginchk(1, 3);
rot_d = varargin{1};
r = [21 10;
    17 14];
if isfield(rot_d, 'r')
    r = rot_d.r;
end
%% uiputfile
if nargin < 10
    [name, path] = my_uiputfile('klayout_src',...
        {'*.txt', 'kLayout CSRR parameters'},...
        'Save kLayout parameters');
    if name == 0
        fpr intf(2, '** no save data\n');
        return
    end
else
    name = varargin{2};
    path = varargin{3};
end
code = varargin{2};
name = [code, '.txt'];


%% write file
% xxx_pars.txt
% xmin,xmax,ymin,ymax
% FCxx-FRxx-Pxx-xxxx
% prefix = name(1:end - 4);
prefix = code;
p = 56;
xmin = -3472;
xmax = -xmin;
ymin = xmin;
ymax = xmax;


fullpath = fullfile(path, [prefix, '_pars.txt']);
fid = fopen(fullpath, 'w+');
fprintf(fid, '%s\n', [num2str(xmin), ',', num2str(xmax), ',', ...
    num2str(ymin), ',', num2str(ymax)]);
fprintf(fid, '%s\n', code);
fclose(fid);


rots = ["rot1", "rot2"];
for i = 1:2
    rot_str = char(rots(i));
    if isfield(rot_d, rot_str)
        
        fullpath = fullfile(path, [prefix, '_', rot_str, '.txt']);
        fprintf(['-- writing file : ', prefix, '_', rot_str, '.txt\n']);
        fid = fopen(fullpath, 'w+');
        for xi = 1:length(rot_d.x)
            for yi = 1:length(rot_d.y)
                xc = rot_d.x(xi) * 1e6;
                yc = rot_d.y(yi) * 1e6;
                % 排除 limit 以外 cell
                if xc < xmin || xc > xmax || yc < ymin || yc > ymax
                    continue
                end
                % 排除额外图案处 cell
                if yc > ymax - p * 3
                    % 定标十字
                    if xc < xmin + p * 6 || xc > xmax - p * 6
                        if yc > ymax - p * 2
                            continue
                        end
                    end
                    % code 字符
                    if xc > xmin + p * 6 && xc < xmin + p * (6+18*2)
                        continue
                    end
                    if xc > xmax - p * (6+18*2) && xc < xmax - p * 6
                        continue
                    end
                end
                if i == 1
                    rot_str = num2str(rot_d.rot1(yi, xi));
                else
                    rot_str = num2str(rot_d.rot2(yi, xi));
                end
                line = [num2str(xc), ',',...
                    num2str(yc), ',',...
                    num2str(r(i, 1)), ',',...
                    num2str(r(i, 2)), ',',...
                    rot_str];
                fprintf(fid, '%s\n', line);
            end
        end
        fclose(fid);
    end
end

end