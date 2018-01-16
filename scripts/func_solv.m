% deep iteration ****** TO DO ******
syms rho fai n k delta lnMT argT w L c

% error function
rho=k*w*L/c+log((4*sqrt(n^2+k^2))/((n+1)^2+k^2))-lnMT;
fai=atan(k/n)-atan(k/(n+1))+(1-n)*w*L/c-argT;
delta=rho^2+fai^2;

% partial derivative
syms d_n d_k dd_nn dd_kk dd_nk
d_n=diff(delta,n);
d_k=diff(delta,k);
dd_nn=diff(d_n,n);
dd_kk=diff(d_k,k);
dd_nk=diff(d_n,k);

