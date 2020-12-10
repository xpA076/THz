% Ex Ey ������ƫ������
% Ex Ey Ϊ����
function data = ellipolar(Ex, Ey)
[r, c] = size(Ex);
data.a = zeros(r, c);                   % ����
data.b = zeros(r, c);                   % ����
data.ecc = zeros(r, c);                 % ������
data.ell = zeros(r, c);                 % ��ƫ��
data.beta = zeros(r, c);                % ��λ��
data.phi = zeros(r, c);                 % a��ת��
for ri = 1:r
    for ci = 1:c
        ex = Ex(ri, ci);
        ey = Ey(ri, ci);
        % ellipolar calculation
        [a, b, ecc, ell, beta, phi] = ellipolar_calc(ex, ey);
        % data
        data.a(ri, ci) = a;
        data.b(ri, ci) = b;
        data.ecc(ri, ci) = ecc;
        data.ell(ri, ci) = ell;
        data.beta(ri, ci) = beta;
        data.phi(ri, ci) = phi;
    end
end

end

function [a, b, ecc, ell, beta, phi] = ellipolar_calc(ex, ey)
% ��λ���һ���� -pi~pi
% beta > 0 : ����(y�����x�� �ͺ�)
% beta < 0 : ����(y�����x�� ��ǰ)
beta  = wrap2(angle(ey) - angle(ex), [-pi pi]);
E0x = abs(ex);
E0y = abs(ey);
theta = atan(E0y/E0x);
% ��e0x=e0*cos(theta),e0y=e0*sin(theta)
E0 = (E0x^2 + E0y^2)^0.5;
tmp_delta = (1 - sin(theta * 2)^2 * sin(beta)^2)^0.5;
a = E0 * ((1 + tmp_delta) / 2)^0.5;
b = E0 * ((1 - tmp_delta) / 2)^0.5;
c = (a^2 - b^2)^0.5;
ecc = c / a; % eccentricity
ell = b / a; % ellipsity
% ��Բ a���b�� ��x����ת��
% phi=0.5*atan(2*e0x*e0y/(e0x^2-e0y^2)*cos(beta));
% phi = 0.5 * atan(tan(theta * 2) * cos(beta));


% ȷ����Բa��ת��
phasex = -0.5 * atan(sin(beta * 2) / (cos(beta * 2) + tan(theta)^-2));
% r1,r2 �ֱ�Ϊa,b��
r1 = (E0x * cos(phasex))^2 + (E0y * cos(phasex + beta))^2;
r2 = (E0x * cos(phasex + pi / 2))^2 + ...
    (E0y * cos(phasex + beta + pi /2 ))^2;
if r1 > r2
    phi = atan(E0y * cos(phasex + beta) / (E0x * cos(phasex)));
else
    phi = atan(E0y * cos(phasex + beta + pi /2) /...
        (E0x * cos(phasex + pi / 2)));
end




end


