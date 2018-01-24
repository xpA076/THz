function delta = thin_film_errorfunction( r,par)  
%计算文献定义的误差函数的值,对应的函数为lsqnonlin
%r = [n2 k2],n2,k2为样品折射率的实部和虚部。即n2-j*k2为样品复折射率
freq = par{1};             %freq为入射光的频率
T_meas = par{2};           %T_meas为对应的实验所测得透射函数值
L = par{3};                %L为样品厚度
n_ref = par{4};           %参考信号通过的物质的折射率，一般为空气
c = 2.99796e8;             %光速
n = r(1)-1i*r(2);
T = (n*n_ref*4/(n+n_ref)^2*exp(-1i*(n-n_ref)*2*pi*freq*L/c))*(1-(((n-1)/(n+1))^2*exp(-2i*n*2*pi*freq*L/c))^5)/(1-((n-1)/(n+1))^2*exp(-2i*n*2*pi*freq*L/c));   %理论计算的光学厚样品透射函数

delta_p = log(abs(T)) - log(abs(T_meas));     
delta_arg = angle(T) - angle(T_meas);
if delta_arg > pi
    delta_arg = delta_arg - 2*pi;
elseif delta_arg < -pi
    delta_arg = delta_arg + 2*pi;
end
% delta_arg = exp(1i*angle(T))-exp(1i*angle(T_meas));
%文献定义的误差函数表达式
delta(1) = delta_p;
delta(2) = delta_arg;
end

