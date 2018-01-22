%% ---------------- Header ---------------
%
% Author: Keno Krewer
% MPIP Mainz, Room 1.503, 0049 6131 379 269
% email: krewer@mpip-mainz.mpg.de
% September 2015; Last revision: 2017-06-09
%
% Terms of use: 
% Academic: Cite "Accurate terahertz spectroscopy of supported thin films
% by precise substrate thickness correction", Krewer et. al., 
% Opt. Lett. 43, 447-450 (2018).
% Commercial: Contact us.
%
% This script calculates dielectric properties of a thin film deposited on  
% a substrate from THz transmitted through the sample and a reference
% substrate. This includes calculating the thickness difference.
%
% Hint: "Fold all" improves the overview tremendously. 
%
% Other m-files required: 
%       computeFieldTransmission.m, 
%       determineThicknessObliqueAngle.m
%       FFT.m
%       importTimeTracesServiceLab.m
%       listFromFolderServiceLab.m
%       plotXYY.m
%       robustStatistics.m
%       thinFilmConductivityObliqueIncidenceTransmission.m
% MAT-files required: refractiveIndex.mat (if measured data is used).
% Import data required: sample and reference time trace

%% ---------------- Outline ------------------------------
% The section constants and definitions initialises global constants used
% in the code, thereby also defining the unit system [Kg um A 1/THz].
%
% The section import imports the THz time traces of reference and sample
% (as measured electro-optical rotations or any quantity proportional to  
% them). As raw data formats differ, I recommend substituting this section 
% with a suitable import. 
%
% The section transmission I computes the direct complex transmission from 
% the time traces. The time window for the direct transmission needs to
% be specified. This function also returns the number of measurements.
% 
% The section transmission II computes the transmission of the first echo.
% The time window for the first echo needs to be specified.
% 
% The section thickness difference computes the thickness difference sample
% and reference substrates. It needs transmission I and II and boundaries
% for the numerical search as input. It further needs the refractive
% index of the substrate, either as measured data in a .mat file or as
% constant value.
%
% The section conductivites computes the complex sheet conductivity of the 
% film. It needs the thickness difference, transmission I and the
% refractive index of the substrate as input.
%
% Other m-files required: a lot
% MAT-files required: refractiveIndex.mat (if measured data is used).
% Import data required: sample and reference time traces
%

%% ---------------- constants and definitions ----------------------------
%
% initialises global constants used in the code, thereby also defining the 
% unit system. Here Kg um ps A;
% Note: use mm or smaller length unit as otherwise the
% numerics in the thickness correction act up.
% needs: nothing.
%

global c0 eps0 Z0 

c0=0.000299792458*10^6;     % [um*THz]          speed of light
Z0=376.73031;               % [V/A] aka [Ohm]   impedance of free space 
eps0=1/(Z0*c0);             % [A/(V*um*THz)]    permitivity of free space

nSi=3.416;              %THz refractive Index of Si, lit value
nBK7=2.45;              %THz refractive Index of BK7, educated guess (check proper value)
nSiO2=1.98;             % 1.98THz refractive index of SiO2, educated guess (check porper value)
nMgOLit=3.46+0.01.*j;      %+0.01.*j; %THz refractive index of MgO, lit value Acta Phys. Sin.  2004, Vol. 53 Issue (6): 1772-1776  
nMgO=3.18;      % My measurement 

refractiveIndex=nMgO;

trimmingPercentage=52;  %percentage of data to be discarded when calculating the trimmed mean

%% ---------------- import time traces----------------------------
%
% imports the THz time traces of reference and sample
% (as measured electro-optical rotations or any quantity proportional to  
% them). As raw data formats differ, I recommend users to substitute this  
% section with a suitable import.
%
% needs: import files to be organise in folder(s), path to the folder
%
% subfuctions: listFromFolderServiceLab, importTimeTracesServiceLab, splitstring.
%
% results: sampleTraces and referenceTraces, format [time trace1 trace2 ..]
%
% also: nMeasurements the number of measurements.

filePath='Fe10nm';             % name of the folder with the data

nMeasurements=30;              % number of measurements, hardscripted in my case

[fileList]=listFromFolderServiceLab(filePath); % gets list of filenames and timesteps

allTimeTraces=importTimeTracesServiceLab(filePath,fileList); %imports time traces

sampleTracesRaw=cell2mat(allTimeTraces(1:nMeasurements)); % pics the sample traces
sampleTraces=[sampleTracesRaw(:,1) sampleTracesRaw(:,2:2:end)]; % converts traces into the required format [time trace1, trace2 ...].

referenceTracesRaw=cell2mat(allTimeTraces(:,nMeasurements+1:end)); % pics the reference traces
referenceTraces=[referenceTracesRaw(:,1) referenceTracesRaw(:,2:2:end)]; % converts them.

[nTimesteps helper]=size(sampleTraces); % calculates the number of timesteps
nMeasurements=helper-1; % and that of measurements

%% ---------------- import refractive index -----------------------
%
% This section imports the refractive index from a .mat file. If a constant
% index should be used, comment this section out and implement one in the 
% constants and definitions section.
%
refractiveIndexFile=load('nMgO.mat');
refractiveIndex=refractiveIndexFile.meanIndex;  % the refractive index of the substrate used

%% ---------------- background correction ------------------------------

%% ---------------- transmission I --------------------------

% computes the direct complex transmission from the time traces. 
% The time window for the direct transmission needs to be specified.
% This function also returns the number of measurements.

% needs: matrices called sampleTraces and referenceTraces of the structure
% [time trace1 trace2....]
%
% subfuctions: FFT, transmission
%
% results: tI, format [frequency transmission1stMeasurement transmission2ndMeasurement ..]
%
% also: nMeasurements the number of measurements.
%

startDirectTransmission=1; % starting time step of the time window for the direct transmission
endDirectTransmission=200; % final step of the window.

[tI]=computeFieldTransmission(referenceTraces, sampleTraces, startDirectTransmission, endDirectTransmission); % the direct transmission, tI in the paper.

[frequencySteps helper]=size(tI);
nMeausurements=helper-1;

%% ---------------- transmission II --------------------------

% The section transmission II computes the transmission of the first echo.
% The time window for the first echo needs to be specified.

% needs: matrices called sampleTraces and referenceTraces of the structure
% [time trace1 trace2....]
%
% subfuctions: FFT, transmission
%
% results: tI, format [frequency transmission1stMeasurement transmission2ndMeasurement ..]
%
% also: nMeasurements the number of measurements.

startEchoTransmission=endDirectTransmission+1; % starting time step of the time window for the first echo transmission
endEchoTransmission=2*endDirectTransmission; % final step of the window.

if(endEchoTransmission-startEchoTransmission~=endDirectTransmission-startDirectTransmission)
    disp('Time windows for direct transmission are not equally long. Make them equal or employ interpolation to obtain values at the same frequencies.')
end

[tII]=computeFieldTransmission(referenceTraces, sampleTraces, startEchoTransmission, endEchoTransmission); % the direct transmission, tI in the paper.

[frequencyStepsII helper]=size(tII);
nMeausurements=helper-1;

if(frequencyStepsII~=frequencySteps)
    disp('frequencies of tI and tII must be identical')
end

%% ---------------- thickness difference -------------------------------

% The section thickness difference computes the thickness difference sample
% and reference substrates. It needs transmission I and II and boundaries
% for the numerical search as input. It further needs the refractive
% index of the substrate, either as measured data in a .mat file or as
% constant value.

% needs: matrices called tI and tII of the structure: 
% [frequency transmissionspectrum1 transmissionspectrum2....]
% and the refractive index of the substrate
%
% input: boundary conditions for the thickness search, angle of incidence,
% frequency region
%
% subfuctions: determineThicknessObliqueAngle, robustStatistics, plotXYY
%
% results: thickness difference and thickness differece error (both in
% [um])
%
% plots: the function to be minimised, histogramm of numeric results,
% results as a function of frequency.
%
% also: nMeasurements the number of measurements.

[frequencySteps helper]=size(tI);
if length(refractiveIndex)==1 % gives the refractive index the require shape if constant value is used.
    refractiveIndex=refractiveIndex*ones(frequencySteps,1);
end


lowerBound=10;     % [um] lower boundary for the search of the thickness difference, refine boundaries b
upperBound=20;      % [um] upper boundary

angleOfIncidence=0;         % [rad] angle of incidence of the THz radiation on the substrate, with respect to the norm.
polarisation='s';           % polarisation of the incident THz, 's' or 0 for perpendicular, 'p' or 1 for parallel

minimumFrequency=0.6;       % [THz] minimum frequency where Signal is stable, check by looking at the mismatch depending on frequency plot
maximumFrequency=2.0;       % [THz] maximum frequency where Signal is stable, 

helper=find(tI(:,1) >= minimumFrequency);
minimumFrequencyIndex=helper(1); %transforms the frequency bounds into frequency steps
helper=find(tI(:,1) <= maximumFrequency); 
maximumFrequencyIndex=helper(end); 

tIcut=tI(minimumFrequencyIndex:maximumFrequencyIndex,:); 
tIIcut=tII(minimumFrequencyIndex:maximumFrequencyIndex,:);
ncut=refractiveIndex(minimumFrequencyIndex:maximumFrequencyIndex,:);

figure('name','expression (13) as a function of thickness differnce') % Figure that holds the plot
thicknessArray=determineThicknessObliqueAngle(tIcut,tIIcut,ncut,lowerBound,upperBound,angleOfIncidence,polarisation); %gives the numerical thickness calculated from expr. (13) and plot expression (13) for the range within the boundaries.

allThicknessWithinRange=reshape(thicknessArray(:,2:end),[],1);
[rows columns]=size(allThicknessWithinRange);
figure('Name','histogramme ')
hist(allThicknessWithinRange,(rows*columns)^0.5);
plotXYY(thicknessArray(:,1),thicknessArray(:,2:end),{'name','thickness difference as a function of frequency','xLabel','Frequency [THz]','yLabel','thicknesses [um]'})   

[thicknessDifference thicknessArrayCovariance]= robustStatistics(allThicknessWithinRange',trimmingPercentage);
thicknessError=thicknessArrayCovariance(1,1)^0.5;

disp(['computed thickness difference is ' num2str(thicknessDifference*10^3) ' nm with ' num2str(thicknessError*10^3) ' nm error'])

%% ---------------- conductivities ------------------------------
% 
% computes the complex sheet conductivity of the 
% film. It needs the thickness difference, transmission I and the
% refractive index of the substrate as input.
%
% needs: matrix called tI  of the structure: 
% [frequency transmissionspectrum1 transmissionspectrum2....]
% and the refractive index of the substrate
%
% input: boundary conditions for the thickness search, angle of incidence
%
% subfuctions: thinFilmConductivityObliqueIncidenceTransmission, robustStatistics
%
% results: thickness difference, format [frequency transmission1stMeasurement transmission2ndMeasurement ..]
%
% also: nMeasurements the number of measurements.

[frequencySteps helper]=size(tI);
if length(refractiveIndex)==1 % gives the refractive index the require shape if constant value is used.
    refractiveIndex=refractiveIndex*ones(frequencySteps,1);
end

angleOfIncidence=0;         % [rad] angle of incidence of the THz radiation on the substrate, with respect to the norm.
polarisation='s';           % polarisation of the incident THz, 's' or 0 for perpendicular, 'p' or 1 for parallel

ThinFilmConductivity=thinFilmConductivityObliqueIncidenceTransmission(tI,refractiveIndex,thicknessDifference,0,'s'); %

 [meanComplexConductivity complexConductivityCov]=robustStatistics(ThinFilmConductivity(:,2:end),trimmingPercentage);
 totalCov=complexConductivityCov;
realSheetConductivityTrimmedMean=[ThinFilmConductivity(:,1) real(meanComplexConductivity) totalCov(:,1,1).^0.5];
    
imagSheetConductivityTrimmedMean=[ThinFilmConductivity(:,1) imag(meanComplexConductivity) totalCov(:,2,2).^0.5];
% figure('Name','Thin film conductivity real (line) and imaginary (x) part')
% plotXYY(ThinFilmConductivity(:,1),[real(ThinFilmConductivity(:,2:end))  imag(ThinFilmConductivity(:,2:end))],{'xLabel','Frequency [THz]','yLabel','sheet conductivity [S]'})

figure('name','conductivites')
    
    errorbar(realSheetConductivityTrimmedMean(minimumFrequencyIndex:maximumFrequencyIndex,1),realSheetConductivityTrimmedMean(minimumFrequencyIndex:maximumFrequencyIndex,2),realSheetConductivityTrimmedMean(minimumFrequencyIndex:maximumFrequencyIndex,3),'r s','DisplayName','real data');
    hold on;
    errorbar(imagSheetConductivityTrimmedMean(minimumFrequencyIndex:maximumFrequencyIndex,1),imagSheetConductivityTrimmedMean(minimumFrequencyIndex:maximumFrequencyIndex,2),imagSheetConductivityTrimmedMean(minimumFrequencyIndex:maximumFrequencyIndex,3),'b s','DisplayName','imag data');

 
   
                                




