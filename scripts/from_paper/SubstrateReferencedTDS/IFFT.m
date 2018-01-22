function RecoveredTimeDomainSignals=IFFT(FrequencyDomainSignals)
    Frequency=FrequencyDomainSignals(:,1);
    [r c]=size(FrequencyDomainSignals);
    if(imag(FrequencyDomainSignals(end,2))==0);
        negativeBranch=conj([flip(FrequencyDomainSignals(2:end-1,2:end))']'/2^0.5);
    else
        negativeBranch=conj([flip(FrequencyDomainSignals(2:end,2:end))']')/2^0.5 ;
    end
    positiveBranch=[FrequencyDomainSignals(1,2:end)' FrequencyDomainSignals(2:end,2:end)'/2^0.5]';
    entireFrequencyDomainSignals=[positiveBranch' negativeBranch']';

    NumberOfFrequencySteps=r;
    NumberOfFrequencySignals=c-1;
    NumberOfTimeSteps=length(entireFrequencyDomainSignals);
    deltaF=abs(Frequency(1)-Frequency(2));
    RecoveredTimeDomainSignals=1.0*1./abs(Frequency(1)-Frequency(2))*linspace(0,1,NumberOfTimeSteps)'-1./abs(Frequency(1)-Frequency(2))/2;%The frequency step is half of the sampling time
    
    for i=1:1:NumberOfFrequencySignals
        RawFourierTransform=ifft(entireFrequencyDomainSignals(:,i))*NumberOfTimeSteps^0.5;%abs(Frequency(end))*2*(2*pi)^0.5;
        RecoveredTimeDomainSignals=[RecoveredTimeDomainSignals RawFourierTransform];
    end
end