function [d_f,d_fft,mgnt,phase]=Process_TDSdata(varargin)
% return fft results of THz_TDS data
% return information : f,fft,magnitude,phase 
f0=3*10^13;
%% process input
narginchk(1,3);
if nargin >= 1
	dat=varargin{1};
end
if nargin >= 2
	cut=varargin{2};
else
	cut=0;
end
if nargin >= 3
	intp=varargin{3};
else
	intp=1;
end
%% cut & interpolation
if cut > 0
	dat=dat(1:cut);
end
dat_intp=dat;
if intp > 1
    for i=(length(dat)+1):(length(dat)*intp)
        dat_intp(i)=0;
    end
end
%% return
dat_f=(0:length(dat)/2-1)';
d_f=dat_f.*(f0/length(dat));            % f
fft_dat=fft(dat);
d_fft=fft_dat(1:length(dat)/2);         % fft
mgnt=abs(d_fft);                     % magnitude
fft_dat_intp=fft(dat_intp);
phase_r=unwrap(angle(fft_dat_intp));
phase=[];
for i=1:length(dat)/2
    phase(i)=phase_r(intp*(i-1)+1);   % phase
end
phase=phase';
