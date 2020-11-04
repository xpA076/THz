load('E:\Projects\Coding\THz_TDS\scripts\standard_data\siml_TDS_air.mat')
f = linspace(0, 15*10^12, 3001);
f(1) = [];
A = spline(x, y, f);
xx = -0.005:5*10^-6:0.005;
ef = exp(2i * pi / (3*10^8) * (f' * xx));
Sxx=A*ef;
plot(xx,real(Sxx))