function [fieldTransmission]=computeFieldTransmission(referenceTimeTraces, sampleTimeTraces, fourierStart, fourierEnd)
%computeFieldTransmissionServiceLab - calculates the field transmission in frequency
%domain. The function undergroundcorrects and fourier transforms reference
%and sample time traces. It then calculates the trimmed mean of the
%reference and devides all samples by it. The standart error of the trimmed
%mean is used to calculate the "Normalisation error". It's relative
%magnitude is equal for all sample traces.
%
% Syntax:  [fieldTransmission normalisationError]=computeFieldTransmission(referenceTimeTraces, sampleTimeTraces, fourierStart, fourierEnd, stepsUsedForUndergroundcorrection, TrimmingPercentage)
%
% Inputs:
%    referenceTimeTraces - time traces of the reference substrate measurement 
%       Structure: [time[ps] trace1 ...traceN]
%    sampleTimeTraces - time traces of the sample measurement 
%       Structure: [time[ps] trace1 ...traceM]
%    fourierStart, fourierEnd: time window that is fourierTransformed
%       Structure: scalar, scaler   units: [timestep/index]
%
% Output:
%    fieldTransmission - array of the complex field transmission 
%       Structure: [frequency transmissionFromTrace1 ....n]
%
% Subfunctions:
%
%       FFT(Timetrace)
%
%     sampleTimeTraces=UndergroundCorrection(sampleTimeTraces,stepsUsedForUndergroundcorrection);%substracts the average of the first StepsUsedForUndergroundcorrection Steps from all the data
%     referenceTimeTraces=UndergroundCorrection(referenceTimeTraces,stepsUsedForUndergroundcorrection);
    
    SampleFrequencyDomain=conj(FFT(sampleTimeTraces(fourierStart:fourierEnd,:))); %performing an inverse FFT from time to frequency domain
    ReferenceFrequencyDomain=conj(FFT(referenceTimeTraces(fourierStart:fourierEnd,:)));
    
    fieldTransmission=[SampleFrequencyDomain(:,1) SampleFrequencyDomain(:,2:end)./ReferenceFrequencyDomain(:,2:end)] ;
    
end