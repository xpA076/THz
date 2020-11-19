function data = cell_data(varargin)
% 处理comsol参数化扫描导出的csv文件
% varargin{1}: model (h1, h2, area, n2)
% varargin{2}: 模式-- 'ask'

% 文件导出格式(COMSOL v5.3)
% 结果-派生值-表面平均值 : 
%     数据集      参数化解
%     参数选择      ---
%     表列        外部解
%     表达式      ewfd.Ex, ewfd.Ey

narginchk(1,2);
%% load
try
    [d,t] = comsol_table_get;
catch
    return
end

model = varargin{1};

xidx = 1;
didx = 2;
if (nargin >= 2)
    if (strcmp(varargin{2}, 'ask'))
        xidx = input('-- x parms column: ');
        didx = input('-- data columns start: ');
    end
end

data.data = d;
data.titles = t;

data.datay = d(:, didx:end);
data.datax = d(:, xidx);
ex = d(:, didx:2:end);
ey = d(:, didx+1:2:end);
data.ex = ex;
data.ey = ey;

if (nargin < 2)
    data.f = data.datax;
else
    iptf = input('-- EM frequency (0 for datax): ');
    if iptf == 0
        data.f = data.datax;
    else
        data.f = iptf;
    end
end

%% proc_data
data = metalens_proc_cell_data(data, model, 'circ');
fprintf('-- data process finished\n');


% area = model.area;
% h1 = model.h1;
% h2 = model.h2;
% n2 = model.n2;
% 
% load_const;
% %% load
% [d,t] = comsol2data;
% data.d = d(:,2:end);
% data.f = d(:,1);
% ex = d(:,2:2:end);
% ey = d(:,3:2:end);
% sConst = calcSConst(n2.^2, area);
% srcp = 2^-0.5*(ex-1i*ey).*sConst;
% slcp = 2^-0.5*(ex+1i*ey).*sConst;
% 
% data.sConst = sConst;
% data.sx = sConst*ex;
% data.sy = sConst*ey;
% 
% data.srcp = srcp;
% data.slcp = slcp;
% data.trcp = abs(srcp);
% data.tlcp = abs(slcp);
% 
% %% phase
% k0 = 2*pi*data.f/c_const;
% k2 = n2.*k0;
% phi0 = k0*h1 + k2*h2;
% 
% 
% %% 结构相位信息
% data.prcp = wrap2( -angle(srcp) - phi0, [-pi pi]);
% data.plcp = wrap2( -angle(slcp) - phi0, [-pi pi]);
% data.px = wrap2( -angle(ex) - phi0, [-pi pi]);
% data.py = wrap2( -angle(ey) - phi0, [-pi pi]);

end
