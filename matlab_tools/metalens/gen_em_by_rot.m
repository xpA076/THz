% EM_data = gen_em_by_rot(EM_rot, rot_d, j_vec)
% EM_rot Ϊ src-data
% rot_d Ϊ x, y, rot1, rot2 ��Ӧ����������ת��
% j_vec Ϊ �����Ų� Jones ʸ��
function EM_data = gen_em_by_rot(EM_rot, rot_d, j_vec)
%% x, y
x = [];
y = [];

for i = 1:length(rot_d.x)
    x = cat(2, x, EM_rot.x + rot_d.x(i));
end
for i = 1:length(rot_d.y)
    y = cat(2, y, EM_rot.y + rot_d.y(i));
end

%% ratio
e_src = j_vec/(sum(j_vec .* conj(j_vec), 1)^0.5);
e_lcp = 2^-0.5 * [1; 1i];
e_rcp = 2^-0.5 * [1; -1i];
% weight
w_lcp = sum(e_src .* conj(e_lcp), 1);
w_rcp = sum(e_src .* conj(e_rcp), 1);


%% Ex, Ey
Ex = zeros(length(y), length(x));
Ey = zeros(length(y), length(x));
for xci = 1:length(rot_d.x)
    for yci = 1:length(rot_d.y)
        % index
        xi1 = (xci - 1) * length(EM_rot.x) + 1;
        xi2 = xci * length(EM_rot.x);
        yi1 = (yci - 1) * length(EM_rot.y) + 1;
        yi2 = yci * length(EM_rot.y);
        % rot index
        r1i = round(rot_d.rot1(yci, xci) / 5);
        r2i = round(rot_d.rot2(yci, xci) / 5);
        Exy = EM_rot.Exy(r1i, r2i);
        % mirror rot index
        r1mi = round(wrap2(90 - rot_d.rot1(yci, xci), [0.5, 360.5]) / 5);
        r2mi = round(wrap2(90 - rot_d.rot2(yci, xci), [0.5, 360.5]) / 5);
        Exy_m = EM_rot.Exy(r1mi, r2mi);
        % copy mat
        % ���������������⣬Ӧ����w_rcp * .. + w_lcp * .. (hhc ,210408)
        % ��������糡Ȩ��, Ӧ�ÿ�������糡�� RCP �ɷֲŶ�
%         Ex(yi1:yi2, xi1:xi2) = w_lcp * Exy.Ex + w_rcp * flipud(Exy_m.Ex);
%         Ey(yi1:yi2, xi1:xi2) = w_lcp * Exy.Ey - w_rcp * flipud(Exy_m.Ey);
        Ex(yi1:yi2, xi1:xi2) = w_rcp * Exy.Ex + w_lcp * flipud(Exy_m.Ex);
        Ey(yi1:yi2, xi1:xi2) = w_rcp * Exy.Ey - w_lcp * flipud(Exy_m.Ey);

    end
end

EM_data.x = x;
EM_data.y = y;
EM_data.Ex = Ex;
EM_data.Ey = Ey;


end