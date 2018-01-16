function delta = thin_film_errorfunction( r,par)  
%�������׶����������ֵ,��Ӧ�ĺ���Ϊlsqnonlin
%r = [n2 k2],n2,k2Ϊ��Ʒ�����ʵ�ʵ�����鲿����n2-j*k2Ϊ��Ʒ��������
freq = par{1};             %freqΪ������Ƶ��
T_meas = par{2};           %T_measΪ��Ӧ��ʵ�������͸�亯��ֵ
L = par{3};                %LΪ��Ʒ���
n_ref = par{4};           %�ο��ź�ͨ�������ʵ������ʣ�һ��Ϊ����
c = 2.99796e8;             %����
n = r(1)-1i*r(2);
T = (n*n_ref*4/(n+n_ref)^2*exp(-1i*(n-n_ref)*2*pi*freq*L/c))*(1-(((n-1)/(n+1))^2*exp(-2i*n*2*pi*freq*L/c))^5)/(1-((n-1)/(n+1))^2*exp(-2i*n*2*pi*freq*L/c));   %���ۼ���Ĺ�ѧ����Ʒ͸�亯��

delta_p = log(abs(T)) - log(abs(T_meas));     
delta_arg = angle(T) - angle(T_meas);
if delta_arg > pi
    delta_arg = delta_arg - 2*pi;
elseif delta_arg < -pi
    delta_arg = delta_arg + 2*pi;
end
% delta_arg = exp(1i*angle(T))-exp(1i*angle(T_meas));
%���׶�����������ʽ
delta(1) = delta_p;
delta(2) = delta_arg;
end

