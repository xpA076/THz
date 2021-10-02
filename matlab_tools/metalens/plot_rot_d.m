function ret = plot_rot_d(rot_d)
figure;
subplot(121);
my_surf(rot_d.x,rot_d.y,rot_d.rot1);
title('Rot1')
subplot(122);
my_surf(rot_d.x,rot_d.y,rot_d.rot2);
title('Rot2')
end
