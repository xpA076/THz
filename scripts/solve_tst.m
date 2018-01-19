% ****** test script ******
syms rho fai n k delta lnMT argT w L c

% error function
rho=k*w*L/c+log((4*sqrt(n^2+k^2))/((n+1)^2+k^2))-lnMT;
fai=atan(k/n)-2*atan(k/(n+1))+(1-n)*w*L/c-argT;
% fai=(1-n)*w*L/c-argT;
delta=rho^2+fai^2;

% partial derivative
syms d_n d_k dd_nn dd_kk dd_nk
d_n=diff(delta,n);
d_k=diff(delta,k);
dd_nn=diff(d_n,n);
dd_kk=diff(d_k,k);
dd_nk=diff(d_n,k);

w=2*pi*10^12;
L=0.0005;
c=3*10^8;
% lnMT=0.7291563;
% argT=-19.675486;
n=3.4;
k=0.0951444;
k*w*L/c+log((4*sqrt(n^2+k^2))/((n+1)^2+k^2))