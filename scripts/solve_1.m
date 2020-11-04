% use the previous solving method from Cai.
r0=[3.4 0];
n=[];
k=[];
d=24.22e-9
n(1)=r0(1);
n(2)=r0(1);
n(3)=r0(1);
k(1)=r0(2);
k(2)=r0(2);
k(3)=r0(2);

for i=1:200
par={f(i);T(i);d;1.00027};
options = optimset('TolFun',1e-16,'TolX',1e-16);
[r,~,residual(i,1:2),~,~] = ...
        lsqnonlin(@(r) thick_errorfunction(r,par),r0,[1 -10],[80 80],options);
r0=r;
n(i)=r(1);
k(i)=r(2);
r0=r;
end

n=n';
k=k';