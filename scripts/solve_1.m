r0=[5 0];
n=[];
k=[];
n(1)=r0(1);
n(2)=r0(1);
n(3)=r0(1);
k(1)=r0(2);
k(2)=r0(2);
k(3)=r0(2);

for i=4:380
par={dat_f(i);T(i);0.000000025;1.00027};
options = optimset('TolFun',1e-16,'TolX',1e-16);
[r,resnorm,residual(i,1:2),exitflag,output] = ...
        lsqnonlin(@(r) thin_errorfunction(r,par),r0,[1 -10],[80 80],options);
r0=r;
[r,resnorm,residual(i,1:2),exitflag,output] = ...
        lsqnonlin(@(r) thin_errorfunction(r,par),r0,[1 -10],[80 80],options);
r0=r;
[r,resnorm,residual(i,1:2),exitflag,output] = ...
        lsqnonlin(@(r) thin_errorfunction(r,par),r0,[1 -10],[80 80],options);
r0=r;
n(i)=r(1);
k(i)=r(2);
r0=r;
end

n=n';
k=k';