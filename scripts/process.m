% get data from file & data fft

% ****** TO DO : GUI ******

A_f0 = 3*10^13;  % A_f0=1/delta_t


% get data from file
[dat1,temp] = getTDSdata('air');
[dat2,temp] = getTDSdata('sample');

dat1 = dat1(:, 2);
dat2 = dat2(:, 2);

[f1, fft1, mgnt1, phase1] = Process_TDSdata(dat1, 600, 30);
[f2, fft2, mgnt2, phase2] = Process_TDSdata(dat2, 600, 30);

T = mgnt2./mgnt1;
dfai = phase2 - phase1;

