% from Cai.
clear;clc
%����LAO��������
format long g
n_ref = 1.00027-0j;       
L = 500e-6;                %��Ʒ���
c = 2.99796e8;             %����
f_beg=0.2;         %%%%%%   ��ͼʱ��ʼƵ��
f_end=2.5;           %%%%%% ��ͼʱ��ֹƵ��

str  = 'VO2 substrate.txt';   %%%%
path0='E:\Tempdata\171227';
path1='E:\Tempdata\171227';  %%%%
cd(path1);   
n = 2;
dir = cell(n,1);
[nm1, pt1] = uigetfile({'*.txt;*.dat',},'Select reference data');
dir{1} = strcat(pt1,nm1);
[nm2, pt2] = uigetfile({'*.txt;*.dat',},'Select sample data');
dir{2} = strcat(pt2,nm2);
cd(path0);

ref_data = TDS_data_extract(dir{1});
samp_data = TDS_data_extract(dir{2});
signal_ref = ref_data(:,2);   
signal_sample = samp_data(:,2);  
time = ref_data(:,1);
figure (1);
set(1,'units','normalized','position',[0.125,0.1,0.55,0.75]);  %(x,y,width,height)
subplot(221);plot(ref_data(:,1)*1e12,signal_ref,samp_data(:,1)*1e12,signal_sample);
legend('reference','sample');
xlabel('delay(ps)');ylabel('signal');

valid = find(time > 0.1e-12 & time < 20e-12);     %�������źź���Ķ��ط��䲿��  
time = time(valid);
signal_ref = signal_ref(valid);      
signal_sample = signal_sample(valid);
subplot(222);plot(time*1e12,signal_ref,time*1e12,signal_sample);
legend('reference','sample');
xlabel('delay(ps)');ylabel('signal');

delta_t =time(2)-time(1);         %��������̫���Ȳ��ε�ȡ��ʱ����
N = 2^(nextpow2(length(time)));   %�ֱ�Բο��źź���Ʒ�ź������ٸ���Ҷ�任
multiple = (N-length(time))/length(time);
fs = 1/delta_t;
f_ref = fft(signal_ref,N);       
f_samp = fft(signal_sample,N);
f_ref = f_ref(1:(N/2+1))/N;
f_samp = f_samp(1:(N/2+1))/N;
f_ref(2:end-1) = f_ref(2:end-1)*2*(1+multiple);
f_samp(2:end-1) = f_samp(2:end-1)*2*(1+multiple);

f = (0:(N/2))*fs/N;   
T_measure = f_samp./f_ref;               %�����ź��ǶԳƵģ�����ֻȡǰ��һ������ݵ�
T_measure = T_measure(1:(N/2+1)).';      %�������õ���͸�亯��       
subplot(2,2,[3,4]);plot(f./1e12,abs(T_measure),'LineWidth',3);
xlabel('frequency');ylabel('transmission');
xlim([f_beg f_end]);ylim([0 1]);

r0 = [5 0];                    %������Ʒ�������ʣ���n2,k2�ĳ�ʼֵ
for ii = 4:(N/2)             %����ii=1��ʼ����ʱ����ʱ��������
    freq(ii) = f(ii);
    T_meas = T_measure(ii);
    par = {freq(ii);T_meas;L;n_ref};  
    %������Ҫ�Ĳ������ֱ�ΪƵ��ֵ����Ӧ��ʵ��͸�亯��ֵ����Ʒ����Լ��ο�������
    options = optimset('TolFun',1e-16,'TolX',1e-16);
    [r,resnorm,residual(ii,1:2),exitflag,output] = ...
        lsqnonlin(@(r) thick_errorfunction(r,par),r0,[1 -10],[80 80],options);  
    n(ii)=r(1);        %��ÿ��Ƶ�ʵ���õ���������ֵ����ڶ�Ӧ��������
    k(ii)=r(2);
    r0 = r;            %��ÿ����õ���������ֵ��Ϊ��һ��Ƶ�ʵ�����ĳ�ʼֵ 
end
re_eps = n.^2-k.^2;
im_eps = 2.*n.*k;
% nk_ref = dlmread('C:\Users\hlcai\Desktop\nk_LAO.txt');
% eps_ref = dlmread('C:\Users\hlcai\Desktop\eps_LAO.txt');
freq = freq./1e12;
figure (2)
set(2,'units','normalized','position',[0.1,0.1,0.7,0.8]);%(x,y,width,height)
%subplot('position',[0.04,0.1,0.44,0.85]);%left bottom width height
subplot(221)
plot(freq,re_eps,'-d','LineWidth',2);%61,308
% h=legend('substrate for sample','substrate for ref');set(h,'fontsize',12);
xlabel('Frequency (THz)','fontsize',12);
ylabel('\epsilon_{real}','fontsize',15);
xlim([f_beg f_end]);
%subplot('position',[0.53,0.1,0.44,0.85])
subplot(222)
plot(freq,im_eps,'-d','LineWidth',2);
% h=legend('substrate for sample','substrate for ref');set(h,'fontsize',12);
xlabel('Frequency (THz)','fontsize',12);
ylabel('\epsilon_{imag}','fontsize',15);
xlim([f_beg f_end]);
subplot(223)
% hold on;
% plot(n_ref(:,1)/1e12,n_ref(:,2),'--r');
plot(freq,n,'-d','LineWidth',2);%61,308
% h=legend('substrate for sample','substrate for ref');set(h,'fontsize',12);
xlabel('Frequency (THz)','fontsize',12);
ylabel('n','fontsize',15);
xlim([f_beg f_end]);
% hold off;
subplot(224)
% hold on;
% plot(n_ref(:,1)/1e12,k_ref(:,2),'--r');
plot(freq,k,'-d','LineWidth',2);
% h=legend('substrate for sample','substrate for ref');set(h,'fontsize',12);
xlabel('Frequency (THz)','fontsize',12);
ylabel('k','fontsize',15);
xlim([f_beg f_end]);ylim([-0.02 0.2]);
hold off;

f_n = [freq' n' k'];
eps = [freq' re_eps' im_eps'];
nk_name = strcat('nk_',str);
eps_name = strcat('eps_',str);
% [row,column]=size(f_n);     %%%%
% fid=fopen(['C:\Users\Hu\Desktop\',nk_name.''],'w'); %%%%
% for ii=1:row
%     for jj=1:column
%         fprintf(fid,'%5f\t',f_n(ii,jj));  %%%%
%         if jj == column
%             fprintf(fid,'\r\n');
%         end
%     end
% end
% fclose(fid);
% fid=fopen(['C:\Users\Hu\Desktop\',eps_name.''],'w'); %%%%
% for ii=1:row
%     for jj=1:column
%         fprintf(fid,'%5f\t',eps(ii,jj));  %%%%
%         if jj == column
%             fprintf(fid,'\r\n');
%         end
%     end
% end
% fclose(fid);