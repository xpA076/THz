% Ex Ey 计算椭偏光数据
% Ex Ey 为矩阵
function data = ellipolar(Ex, Ey)
[r, c] = size(Ex);
data.a = zeros(r, c);                   % 长轴
data.b = zeros(r, c);                   % 短轴
data.ecc = zeros(r, c);                 % 离心率
data.ell = zeros(r, c);                 % 椭偏度
data.beta = zeros(r, c);                % 相位差
data.phi = zeros(r, c);                 % a轴转角
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
% 相位差归一化到 -pi~pi
% beta > 0 : 左旋(y轴相对x轴 滞后)
% beta < 0 : 右旋(y轴相对x轴 超前)
beta  = wrap2(angle(ey) - angle(ex), [-pi pi]);
E0x = abs(ex);
E0y = abs(ey);
theta = atan(E0y/E0x);
% 令e0x=e0*cos(theta),e0y=e0*sin(theta)
E0 = (E0x^2 + E0y^2)^0.5;
tmp_delta = (1 - sin(theta * 2)^2 * sin(beta)^2)^0.5;
a = E0 * ((1 + tmp_delta) / 2)^0.5;
b = E0 * ((1 - tmp_delta) / 2)^0.5;
c = (a^2 - b^2)^0.5;
ecc = c / a; % eccentricity
ell = b / a; % ellipsity
% 椭圆 a轴或b轴 与x轴旋转角
% phi=0.5*atan(2*e0x*e0y/(e0x^2-e0y^2)*cos(beta));
% phi = 0.5 * atan(tan(theta * 2) * cos(beta));


% 确定椭圆a轴转角
phasex = -0.5 * atan(sin(beta * 2) / (cos(beta * 2) + tan(theta)^-2));
% r1,r2 分别为a,b轴
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


