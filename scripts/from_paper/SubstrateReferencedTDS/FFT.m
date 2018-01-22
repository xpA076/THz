
function FrequencyDomainSignals=FFT(TimeTraces)
    TimeSignal=TimeTraces(:,1);
    [r c]=size(TimeTraces);
    NumberOfTimesteps=r;
    NumberOfTimeTraces=c-1;
    NumberOfFrequencySteps=floor(NumberOfTimesteps/2)+1;
    MaxFrequency=1.0/2*1./abs(TimeSignal(1)-TimeSignal(2));
    
    FrequencyDomainSignals=MaxFrequency*linspace(0,1,NumberOfFrequencySteps)';%The frequency step is half of the sampling time
    for i=1:1:NumberOfTimeTraces
        RawFourierTransform=fft(TimeTraces(:,1+i))/(NumberOfTimesteps)^0.5;        
        FrequencyDomainSignals=[FrequencyDomainSignals [RawFourierTransform(1) RawFourierTransform(2:NumberOfFrequencySteps)'*2^0.5]'];
    end
end
