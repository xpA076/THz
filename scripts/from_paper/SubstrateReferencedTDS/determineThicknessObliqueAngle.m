function thicknessArray=determineThicknessObliqueAngle(Transmission1,Transmission2,refractiveIndex,LowerBound,UpperBound,angleOfIncidence,polarisation)
%determineThicknessObliqueAngle - calculates difference between ref and sample substrate
%from 2nd reflection. From the first and second reflection, together with the
%refractive index of the substrate, the thickness difference is solved for
%numerically for each frequency. Reasonable upper and lower bounds to the
%thickness difference are necesarry, as otherwise several solutions appear.
%
% Syntax:  determineThicknessObliqueAngle = function_name(Transmission1,Transmission2,refracitveIndex,LowerBound,UpperBound,angleOfIncidence,polarisation)
%
% Inputs:
%    Transmission1 - 1.st order transmission. 
%       Structure: [frequency trace1 ...traceN]
%    Transmission2 - 2nd order transmission. Same structure as Transm.1
%    refracitveIndex - Substrate refractive index
%       Structure: [frequnecy indexValue]
%    LowerBound - Lower limit of the possible thickness intervall
%       Structure: scalar variable [m]
%    UpperBound - Upper limit of the possible thickness intervall
%       Structure: scalar variable [m]
%    angleOfIncidence - angle between incoming beam and surface normal  
%       Structure: scalar variable [radiant]
%    polarisation - polaristaion of incoming beam:
%               's' or 0 for perpendicular, 'p' or 1 for parallel to plane
%               of incidence.
%
% Output:
%    thicknessArray - array of the thickness differences for differnt
%    traces and frequencies
%       Structure: [frequency thicknessFromTrace1 ....n], unit [m]

if(strcmp(polarisation,'s'))  
    p=0;
elseif(strcmp(polarisation,'p'))
    p=1;
else
    p=polarisation;
end

 global c0              %loads global speed of light, this defines the unit system.
    aoi1=angleOfIncidence; %angle of incidence in medium 1 (air)

transmissionRatio=[Transmission1(:,1) Transmission2(:,2:end)./Transmission1(:,2:end)];
[freqencyNumber datasetNumber]=size(Transmission1);
thicknessArray=zeros(size(Transmission1));
dicken=[LowerBound:(UpperBound-LowerBound)/200:UpperBound];

for a=1:1:freqencyNumber
    for b=2:1:datasetNumber
        t21=transmissionRatio(a,b);
        t1=Transmission1(a,b);
        n1=1;
        n3=refractiveIndex(a,1);
        aoi3=asin(n1.*sin(aoi1)./n3); %angle of incidence in medium 3 (substrate)
        if p==1
            n1a=n1.*cos(aoi3);
            n3a=n3.*cos(aoi1);
        else
            n1a=n1.*cos(aoi1);
            n3a=n3.*cos(aoi3);
        end
        f=Transmission1(a,1);
        Needs2BeZero = @(d) abs(t21.*(n3a-n1a)-2.*n3a.*t1.*exp(1i.*(n3.*cos(aoi3)+n1.*cos(aoi1)).*2*pi*d.*f/c0)+(n3a+n1a).*exp(1i*(2.*n3.*cos(aoi3))*2*pi*d.*f/c0));
        thicknessArray(a,b)=fminbnd(Needs2BeZero, LowerBound, UpperBound);
        plot(dicken,Needs2BeZero(dicken))
        hold on

    end 
end

thicknessArray(:,1)=Transmission1(:,1);

end

