% get data from file & data fft

A_f0=3*10^13;  % A_f0=1/delta_t


% get data from file
dat1=Get_TDSdata('air');
dat2=Get_TDSdata('sample');

[f1,fft1,mgnt1,phase1]=Process_TDSdata(dat1,0,30);
[f2,fft2,mgnt2,phase2]=Process_TDSdata(dat2,0,30);

T=mgnt2./mgnt1;


