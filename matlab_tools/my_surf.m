function ret = my_surf(varargin)
% my_surf(vecx, vecy, data, title, grid-on)
%% argin
vecx = varargin{1};
vecy = varargin{2};
data = varargin{3};

%% visualize
[X, Y] = meshgrid(vecx, vecy);
if nargin < 5
    ret = surf(X, Y, data, 'linestyle', 'none');
else
    ret = surf(X, Y, data);
end
colorbar;
colormap jet;
xlim([vecx(1) vecx(end)]);
ylim([vecy(1) vecy(end)]);
if length(vecx) == length(vecy)
    axis equal
end
view([0 90]);

if nargin >=4
    title(varargin{4});
end



end