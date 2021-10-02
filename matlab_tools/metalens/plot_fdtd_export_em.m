femd = fdtd_get_em;
if length(femd.z) == 1
    plot_fdtd_em(femd, 'xy');
elseif length(femd.x) == 1
    plot_fdtd_em(femd, 'yz');
elseif length(femd.y) == 1
    plot_fdtd_em(femd, 'xz');
end






