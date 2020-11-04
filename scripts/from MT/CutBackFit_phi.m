% Fitting THz unwrapped data with the form:
% phi_k(w)=phi_k0-w/c*((neff-1)*Lk+Lpath)
%
% This fit is inherently degenerate with respect to the following transformation:
% phi_k(w)=[phi_k0+d*Lk]-w/c*(([neff+d*c/w]-1)*Lk+Lp)
%
% Parameter d can be chosen from a physical model. For example, for a TIR fiber
% we require that b(w)->0 wen w->0.
% Npol is the polynomial order used in the approximation of neff
% neff=n0+b1*w+b2*w^2; in this case Npol=2 and D=D0+D1*w

function [wf,nefff,D, Lpath, phi0,beff] = CutBackFit_phi(phi,L,w,Npol,wmin,wmax)
c=3e8/1e12/(2*pi);% L is in [m] and w is in [THz].

Ns=length(L);
Nw=length(w);

Lav=sum(L)/Ns;
L2av=sum(L.^2)/Ns;
dL2=L2av-Lav^2;

wav=sum(w/c)/Nw;
w2av=sum((w/c).^2)/Nw;

M=zeros(Ns+1,Ns+1); RHS=zeros(Ns+1,1);
for k=1:Ns+1
    if (k<=Ns)
        RHS(k)=L(k)/L2av*sum(sum(phi.*(ones(Nw,1)*L)))/Ns/Nw-sum(phi(:,k))/Nw;
    else
        RHS(k)=-sum(((w/c)*phi).*(L2av-Lav*L))/Ns/Nw;
    end
    for kp=1:Ns+1
        if (k<=Ns)&&(kp<=Ns)
            if (k==kp) M(k,kp)=M(k,kp)-1; end
            M(k,kp)=M(k,kp)+L(kp)*L(k)/Ns/L2av;
        end
        if (k<=Ns)&&(kp==Ns+1)
            M(k,kp)=-wav*(L(k)*Lav/L2av-1);
        end
        if (k==Ns+1)&&(kp<=Ns)
            M(k,kp)=-wav/Ns*(L2av-Lav*L(kp));
        end
        if (k==Ns+1)&&(kp==Ns+1)
            M(k,kp)=w2av*dL2;
        end
    end
end

[U,S,V] = svd(M);
x=V(1:Ns+1,1:Ns)*diag(1./diag(S(1:Ns,1:Ns)))*(U(1:Ns+1,1:Ns)'*RHS);
Lpath=x(end);phi0=x(1:end-1)';

% d=(phiar(1)-x(1))/L(1); % this is only for a test
d=0;
beff=d+w'/c*(1-Lpath*Lav/L2av)+(sum(phi0.*L)/Ns-(phi*L')/Ns)/L2av;
% figure(20);plot(w,beff)
% we now fit :
% n=d*c/w+n0+b1*(w/c)+b2*(w/c)^2;
% beff = d+n0*(w/c)+b1*(w/c)^2+b2*(w/c)^3;
% In this case dispersion:
% D=1/c*d^2(w*neff)/dw^2=2*b1/c^2+6*b2/c2*w/c;
ind=find((w>=wmin)&(w<=wmax));
wf=w(ind);befff=beff(ind);Nwf=length(wf);
p=polyfit(wf/c,befff',Npol+1)

nefff=1-Lpath*Lav/L2av+(c./wf').*(-p(end)+(sum(phi0.*L)/Ns-(phi(ind,:)*L')/Ns)/L2av);
phi0=phi0-p(end)*L;

D=zeros(size(wf));
nefffth=zeros(size(wf));
for j=Npol:-1:0
    nefffth=nefffth+p(Npol-j+1)*(wf/c).^j;
end
for j=Npol:-1:1
    D=D+(j+1)*j*p(Npol-j+1)*(wf/c).^(j-1);
end
D=D/c^2*1e-2/(2*pi)^2; % ps/(THz*cm)

diff=0;
figure(21)
cc={'b','g','r','c','m','y','k','b','g','r','c','m','y','k'};
for k=1:Ns
    plot(wf,phi(ind,k)-phi0(k),cc{k}); if (k==1) hold; end
    phith=-wf'/c.*((nefff-1)*L(k)+Lpath);
    plot(wf,phith,[':' cc{k}])
    diff=diff+sum(abs(phith-phi(ind,k)))/Nwf;
end
hold
xlabel('\omega')
ylabel('\phi(\omega)')
for k=1:Ns;leg{k}=[num2str(L(k)*100) ' cm'];end
legend(leg);

diff=diff/Ns/2/pi;% measure of error in the fitted pahase per measurementin units of 2*pi
display(['Measure of error in phase per point in units of 2*pi: ' num2str(diff)])

figure(22)
plot(wf,nefff,'b',wf,nefffth,':r')
xlabel('\omega')
ylabel('n_{eff}')
Err_neff=sum(abs(nefff-nefffth'))/Nwf;
display(['Measure of error in neff vs. polynomial approximation: ' num2str(Err_neff)])

figure(23)
plot(wf,D,'r')
xlabel('\omega')
ylabel('D [ps/(THz\cdotcm)]')
