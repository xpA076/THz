% Ex Ey 仿真数据计算椭偏光数据
% Ex Ey 为复数，代表x,y方向电场透过率，输入n*2矩阵
function data=ellipolar(E)
    A=[];B=[];
    Ecc=[];Ell=[];
    Beta=[];Phi=[];
    for ii=1:2:size(E,2)
        A_=[];B_=[];
        Ecc_=[];Ell_=[];
        Beta_=[];Phi_=[];
        for i=1:size(E,1)
            ex=E(i,ii);
            ey=E(i,ii+1);
            % 相位差归一化到 -pi~pi
            % beta > 0 : 左旋(y轴相对x轴相位滞后)
            % beta < 0 : 右旋(y轴相对x轴相位超前)
            tmp_b=(angle(ex)-angle(ey))/(2*pi);
            beta=(tmp_b-floor(tmp_b+0.5))*(2*pi);
            e0x=abs(ex);
            e0y=abs(ey);
            theta=angle(e0x+e0y*1i);
            % 令e0x=e0*cos(theta),e0y=e0*sin(theta)
            e0=abs(e0x+e0y*1i);
            tmp_delta=(1-sin(theta*2)^2*sin(beta)^2)^0.5;
            a=e0*((1+tmp_delta)/2)^0.5;
            b=e0*((1-tmp_delta)/2)^0.5;
            c=(a^2-b^2)^0.5;
            eccentricity=c/a;
            ellipsity=b/a;
            % 椭圆 a轴或b轴 与x轴旋转角
            % phi=0.5*atan(2*e0x*e0y/(e0x^2-e0y^2)*cos(beta));

            % 确定椭圆a轴转角
            phasey=-0.5*atan(sin(beta*2)/(cos(beta*2)+tan(theta)^2));
            % r0,r1分别为a,b轴
            r0=abs(e0x*cos(phasey+beta)+1i*e0y*cos(phasey));
            r1=abs(e0x*cos(phasey+pi/2+beta)+1i*e0y*cos(phasey+pi/2));
            if(r0>r1)
                phi=atan(e0y*cos(phasey)/(e0x*cos(phasey+beta)));
            else
                phi=atan(e0y*cos(phasey+pi/2)/(e0x*cos(phasey+pi/2+beta)));
            end

            A_=[A_;a];B_=[B_;b];
            Ecc_=[Ecc_;eccentricity];Ell_=[Ell_;ellipsity];
            Beta_=[Beta_;beta];Phi_=[Phi_;phi];
        end
        A=[A A_];B=[B B_];
        Ecc=[Ecc Ecc_];Ell=[Ell Ell_];
        Beta=[Beta Beta_];Phi=[Phi Phi_];
    end
    % return
    data.a=A;                   % 长轴
    data.b=B;                   % 短轴
    data.ecc=Ecc;               % 离心率
    data.ell=Ell;               % 椭偏度
    data.beta=Beta/(2*pi);      % 相位差 (单位: 2*pi)
    data.phi=Phi;               % a轴转角

end
