% num=xlsread('data','K2:L201')
% used in date_180328
dat_f=xlsread('data','N2:N41');
T=xlsread('data','Z2:Z41');
solve_1;
plot(dat_f,n,dat_f,k);
mm=[n,k];
save Znk.txt mm -ascii