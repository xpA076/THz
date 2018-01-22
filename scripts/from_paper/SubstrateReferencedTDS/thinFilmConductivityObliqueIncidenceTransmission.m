function sheetConductivity=thinFilmConductivityObliqueIncidenceTransmission(Fieldtransmission,RefractiveIndex,ThicknessDifference,angleOfIncidence,polarisation)
%thinFilmConductivityObliqueIncidenceTransmission -calculates the complex sheet
%conductivity from the field transmission and the substrate Index.
%
% Syntax:  sheetConductivity=thinFilmConductivityObliqueIncidenceTransmission(Fieldtransmission,RefractiveIndex,angleOfIncidence,polarisation,ThicknessDifference)
% 
% Inputs:
%    Fieldtransmission - the transmitted field of sample+substrate relative to just (reference) substrate  
%       Structure: [frequency trace1 ... tranceN]; frequency units: [THz]
%    RefractiveIndex - the (possibly frequency dependend refractive index
%    of the substrate
%       Structure: [frequencyList indexList]*, or [dummie constantIndex]
%       *untested
%    angleOfIncidence - angle of incidence (in air)
%       Structure: real number [radiant]
%    polarisation - the orientation of the E-field to the plane of
%    incidence
%       Structure: 's' or 0 for perpendicular, 'p' or 1 for parallel 
%    ThicknessDifference - the thickness difference between sample
%    substrate and reference substrate
%       Structure: real number [mm]
%
% Output:
%    ThinFilmConductivityWithThicknessDifference - the frequency dependent complex conductivity of the sample 
%       Structure: [frequency trace1 ... traceN] frequency units: [THz]

    sheetConductivity=Fieldtransmission(:,1);
    [rows cols]=size(Fieldtransmission);
    
    if polarisation=='p'
        o=1;
    elseif polarisation=='s'
        o=0;  
    elseif polarisation==1
        o=1; 
    elseif polarisation==0
        o=0;
    else
        print('no defined polarisation state')
    end
    
    n=RefractiveIndex(:,1);
    global c0 Z0
  
    aoi1=angleOfIncidence; %angle of incidence in medium 1 (air)
    aoi3=asin(1.*sin(aoi1)./n); %angle of incidence in medium 3 (substrate)
    
    if o==1 %calculating polarisation dependent coefficients
        y13=cos(aoi3);
        y23=cos(aoi3);
        b12=cos(aoi1);
        b13=cos(aoi1);
    else
        y13=cos(aoi1);
        y23=1;
        b12=1;
        b13=cos(aoi3);
    end
   
    phaseAdjustment=exp(2*pi*1i*(-n.*cos(aoi3)+1.*cos(aoi1)).*ThicknessDifference./c0.*Fieldtransmission(:,1));  %the phase difference from the thickness difference
    
    for i=2:1:cols
        t=Fieldtransmission(:,i).*phaseAdjustment; %adjusting the phase for thickness difference
        sheetConductivity=[sheetConductivity (1.*y13+n.*b13).*(1-t)./(t.*Z0.*y23.*b12)]; 
    end
 
end