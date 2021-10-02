function ret = plot_fdtd_em(EM_data, type)
figure;
if type == 'xy'
    vec1 = EM_data.x;
    vec2 = EM_data.y;
elseif type == 'yz'
    vec1 = EM_data.y;
    vec2 = EM_data.z;
elseif type == 'xz'
    vec1 = EM_data.x;
    vec2 = EM_data.z;
end
    


subplot(231)
my_surf(vec1, vec2, abs(EM_data.Ex));
title('Ex intensity');

subplot(232)
my_surf(vec1, vec2, 2^-0.5 * abs(EM_data.Ex + 1i * EM_data.Ey));
title('RCP intensity');

subplot(233)
my_surf(vec1, vec2, 2^-0.5 * abs(EM_data.Ex - 1i * EM_data.Ey));
title('LCP intensity');

subplot(234)
my_surf(vec1, vec2, abs(EM_data.Ey));
title('Ey intensity');

subplot(235)
my_surf(vec1, vec2, angle(EM_data.Ex + 1i * EM_data.Ey));
title('RCP phase');

subplot(236)
my_surf(vec1, vec2, angle(EM_data.Ex - 1i * EM_data.Ey));
title('LCP phase');


end