function EM_data = comsol_get_grid_em(varargin)
if nargin == 0
    data = comsol_get_grid;
else
    data = comsol_get_grid(varargin{1}, varargin{2});
end

EM_data.x = data(1).x;
EM_data.y = data(1).y;
EM_data.Ex = data(1).data;
EM_data.Ey = data(2).data;

end