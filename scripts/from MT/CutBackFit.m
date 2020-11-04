% Extraction of cutback losses from the fiber transmission data
% The fit assumes frequency dependent coupling efficiency given by C(w),
% as well as overall power fluctuation given by As.
%
% Input:
% 1) Transmission spectra E(1:Nw, 1:Ns), where each column contains an
% absolute value of the Fourier transmission spectra (column of of size Nw),
% and there are Ns transmission spectra in total.
% 2) L(1:Ns) Fiber lengths at which transmission spectra have been measured.
% 3)    if polynome is specified, additional fit of the loss is performed:
%       polynome=2, alpha=alpha1*w^2
%       polynome=4, alpha=alpha1*w^2+alpha2*w^4
%
% Output:
% The data is fitted togeter with the following fit function:
%
% E(w)=A*C(w)*exp(-alpha(w)*L)
% using the following weighting function:
% Q=sum(s,s',i) (log(Es(wi))-log(Es'(wi))-log(As)+log(As')+alpha(wi)*(Ls-Ls'))^2
%
% 1) A(1:Ns) - matrix of coefficients that characterise overall power
% fluctuation between defferent measurements. A(1)=1 by default. Normally,
% if the power fluctuations of a laser source are small, and the fiber
% coupling conditions are unchanged between experiments, A~1.
% 2) C(w) - frequency dependent excitation spectrum is not an optimisation
% parameter. However, it is supposed to be constant from one measurement to
% another.
% 3) alpha(w) - frequency dependent extinction coefficient in the units of
% 1/[L].
% 4) delta_C - estimate of the consistency in excitation specrea C (0<delta_C<~1)
% this parameter is a relative standard deviation in the value of the supposedely constant
% excitation spectra C(w) that is averaged over different spectra and frequency. Ideally
% delta_C=0, if the functional form of the fit is well chosen.
% 5) poly_fit - alpha1 and alpha 2 coefficients in the polynomial fit of
% losses alpha=alpha1*w^2 or alpha=alpha1*w^2+alpha2*w^4.
% 6) delta_alpha - quality of the polynomial fit of the loss data. This is a relative 
% variation between the fit and the extracted loss.
%
% Important:
% Strictly speaking, the problem is ill determined. There is no unique
% solution to the values of A. In fact, if A=A0 is a solution, then
% A=A0*b*exp(alpha0*L) is also a solution for any choice of b and alpha0 as:
% E=[A*b*exp(alpha0*L)]*[C/b]*exp(-(alpha+alpha0)*L)=A*C*exp(-alpha*L)
%
% If polynomial form for alpha is not specified, we choose b and alpha0 in order to minimise
% variation in the values of log(A), which corresponds to the experiment
% that tries to realise the same coupling conditions in every measurement.
% In fact, in this algorithm not only the variance of log(A) is minimized, but
% also, the average of log(A) is zero. This optimisation is equivalent to
% optimization of the varience of coefficients A that vary randomly and weakly
% around 1. The algorithm will shif losses by a certain constant if power varies too
% strongly.

function [A,C,alpha,delta_C,poly_fit,delta_alpha] = CutBackFit(E,L,w,polynome)

flag=0;
if (nargin<2) display('Insufficient number of input data.'); return; end

[d1,d2]=size(L);
if (d1~=1)&(d2~=1)
    display('Error in the dimension of a length array'); return;
elseif (d1~=1) L=L';Ns=d1;
else Ns=d2;
end

[d1,d2]=size(E);
if (d1~=Ns)&(d2~=Ns)
    display('Error in the dimensions of a spectral array');return;
elseif (d2~=Ns) E=E';Nw=d2;
else Nw=d1;
end

if(nargin == 4)
    flag = 1;
    [d1,d2]=size(w);
    if (d1==1)&(d2==Nw) w=w';
    elseif (d1==Nw)&(d2==1);
    else
        display('error in the dimension of the frequency array'); return;
    end
end

Lav=sum(L)/Ns;
dL2=sum(L.^2)/Ns-Lav^2;

lE=log(E);
if (Nw>1) lEav=sum(lE)/Nw;
else lEav=lE; end

M=zeros(Ns,Ns); RHS=zeros(Ns,1);
for s=1:Ns
    RHS(s)=-lEav(s);
    for sp=1:Ns
        fssp=(1+(L(s)-Lav)*(L(sp)-Lav)/dL2);
        M(s,sp)=fssp/Ns;
        RHS(s)=RHS(s)+lEav(sp)*fssp/Ns;
        if (s==sp) M(s,s)=M(s,s)-1; end
    end
end

[U,S,V] = svd(M);
lA1=V(1:Ns,1:Ns-2)*diag(1./diag(S(1:Ns-2,1:Ns-2)))*(U(1:Ns,1:Ns-2)'*RHS);
% lA1 is a degenerate solution. lA=lA1+log(b)+alpha0*L is also a solution
% for any choice of b and alpha0 as:
% E=[A1*b*exp(alpha0*L)]*[C/b]*exp(-(alpha+alpha0)*L)=A1*C*exp(-alpha*L)
%
% At this point, the C coefficients are still defined up to a factor of
% CS=exp(alphaC*L)*C. We now fing alpha C in order to minimize the difference
% between coupling coefficients:

A1=exp(lA1');
alpha1=sum(A1.*(L-Lav))/Ns/dL2*ones(Nw,1)-lE*((L-Lav)')/Ns/dL2;
CS=(E.*exp(alpha1*L)).*(ones(Nw,1)*(1./A1));
alphac=sum((log(CS)*L')/Ns-(log(CS)*ones(Ns,1))/Ns*Lav)/Nw/dL2;
C=CS.*(ones(Nw,1)*exp(-alphac*L));
A2=A1.*exp(alphac*L);
lA2=log(A2');

% Estimate on the quality of the fit - delta (0<delta<~1)
% this parameter is a relative standard deviation in the value of the coupling
% efficiency that is averaged over different spectra and frequency. ideally
% delta=0, if the functional form of the fit is well chosen.
Cav=sum(C')'/Ns;dC2=abs(sum((C.^2)')'/Ns-Cav.^2);
delta_C=sum(sqrt(dC2)./Cav)/Nw;
display(['Excitation spectrum consistency = ' num2str(delta_C), '(0 - perfect fit, ~1 - bad fit)'])

% To calculate alpha, we further choose b and alpha0 in order to minimise
% variation in the values of log(A), which corresponds to the experiment
% that tries to realise the same coupling conditions in every measurement.
% Also we choose coefficient b so that sum(log(A))=0;
alpha0=-(sum(lA2'.*L)/Ns-sum(lA2)/Ns*Lav)/dL2;
alpha=alpha1+alpha0;
A=A2.*exp(alpha0*L);
b=exp(-sum(log(A)));A=A*b;C=C/b;

poly_fit=[];delta_alpha=[];
if (flag)
    wn=sum(w)/Nw;wf=w/wn;
    if (polynome==2)
        MMM=[[1 sum(wf.^2)/Nw];[sum(wf.^2)/Nw sum(wf.^4)/Nw]];
        RHSy=[sum(alpha)/Nw;sum(alpha.*(wf.^2))/Nw];
        y=MMM\RHSy;
        alpha=alpha-y(1);A=A.*exp(-y(1)*L);
        poly_fit=[poly_fit y(2)/wn^2];
        thalpha=poly_fit(1)*w.^2;
        dalpha=alpha-thalpha;
    elseif (polynome==4)
        MMM=[[1 sum(wf.^2)/Nw sum(wf.^4)/Nw];[sum(wf.^2)/Nw sum(wf.^4)/Nw sum(wf.^6)/Nw];[sum(wf.^4)/Nw sum(wf.^6)/Nw sum(wf.^8)/Nw]];
        RHSy=[sum(alpha)/Nw;sum(alpha.*(wf.^2))/Nw;sum(alpha.*(wf.^4))/Nw];
        y=MMM\RHSy;
        alpha=alpha-y(1);A=A.*exp(-y(1)*L);
        poly_fit=[poly_fit y(2)/wn^2 y(3)/wn^4];
        thalpha=poly_fit(1)*w.^2+poly_fit(2)*w.^4;
        dalpha=alpha-thalpha;
    end
    delta_alpha=sqrt(sum(dalpha.^2)/Nw)/(sum(thalpha)/Nw);
    display(['Quality of the polynomial fit of losses = ' num2str(delta_alpha), '(0 - perfect fit, ~1 - bad fit)'])
end

Ef=exp(-alpha*L).*(C.*(ones(Nw,1)*A));

figure(1)
if (nargin>2)
    plot(w,E,'-',w,Ef,':')
    xlabel('\omega')
    ylabel('Spectrum E [AU]')
else
    plot((1:Nw),E,'-',(1:Nw),Ef,':');
    ylabel('Spectrum E [AU]')
end
title('Fitted spectra E=A\cdotC(\omega)*exp(\alpha(\omega)\cdotL). (-) original data; (:) fitting.')
axis tight

figure(2)
if (nargin>2)&(nargin<4)
    plot(w,alpha,'-')
    xlabel('\omega')
    ylabel('Loss \alpha(\omega) [L^{-1}]')
else
    plot((1:Nw),alpha,'-');
    ylabel('Loss \alpha(\omega) [L^{-1}]')
end
if (flag)
    if (polynome==2)
        plot(w,alpha,'-',w,thalpha,':')
        str2=['\alpha(\omega)=' num2str(poly_fit(1)) '*w^2'];
        title(['Absorption losses, units [L^-1]. (Fitted to ' str2 ').']);
        xlabel('\omega')
        ylabel('Loss \alpha(\omega) [L^{-1}]')
    elseif (polynome==4)
        plot(w,alpha,'-',w,thalpha,':')
        str4=['\alpha(\omega)=' num2str(poly_fit(1)) '*w^2+' num2str(poly_fit(2)) '*w^4'];
        title(['Absorption losses, units [L^-1]. (Fitted to ' str4 ').']);
        xlabel('\omega')
        ylabel('Loss \alpha(\omega) [L^{-1}]')
    end
else
    title('Absorption losses \alpha(\omega), units [L^-1]. (Minimized variation in the coupling coefficients).')
end
axis tight

figure(3)
if (nargin>2)
    plot(w,C,'-',w,Cav,':')
    xlabel('\omega')
    ylabel('Excitation spectrum C(\omega) [AU]')
else
    semilogy((1:Nw),C,'-',(1:Nw),Cav,':');
    ylabel('Excitation spectrum C(\omega) [AU]')
end
title('Excitation spectrum C(\omega), units [AU]. (-) individual experiments; (:)average.')
axis tight
