function [TrimmedMean CovariancesOfTrimmedMean]=robustStatistics(Data,trimmingPercentage)
%robustStatistics - gives an spectrum of the trimmed (amplitude) mean of multiple spectra
%It is optimised for complex numbers 
%
% Syntax: [TrimmedMean CovariancesOfTrimmedMean]=RobustStatistics(Data,trimmingPercentage)
%
%   Input:
%       Data - The dataset to be trimmed
%       
%   Output:
%       meanVector, vectorOfCovarianceMatrices
%
correctionValues52=[1.09504960257600 1.06278373779742 0.664422576757143 0.745230557387095 0.769888996871073 0.792754563752242 0.650651365825282 0.674326427079750 0.691069870836597 0.712054195780672 0.615590098041615 0.632625960182245 0.654773497018764 0.662039695849059 0.597360313809529 0.609836566351000 0.625032273016232 0.639711004782039 0.587409026975363 0.598339952835267 0.611033977236677 0.617659232180343 0.582252491208554 0.587931125162200 0.597402357159809 0.563403968541718 0.569551249940683 0.582638799471697 0.592353911628104 0.557883569978250 0.569896471281936 0.577012867706800 0.587626325482231 0.560648360720399 0.565742895043660 0.569716500781792 0.578821437222908 0.551041865392445 0.562319294700845 0.566572528748880 0.576640797469816 0.551647673381909 0.556854481622969 0.564276845742652 0.571466561901726 0.553867211882339 0.561200678573857 0.561087067202405 0.543365214997900 0.549595740997539 0.555049736229482 0.559298934230410 0.542746431729399 0.549161030970000 0.554594083756680 0.559902757376044 0.543404464156078 0.549009338690723 0.554661456129263 0.559566102433173 0.542681897004498 0.546288335071312 0.549863044891719 0.555350277940840 0.541885801363559 0.546159266624448 0.554199263616721 0.555566521908826 0.540756656255226 0.545272122255748 0.548072672536537 0.553147379157797 0.539825561433325 0.544417885063393 0.547608251657669 0.536404714296568 0.540263719424631 0.545106825083359 0.547591384886531 0.536356922696343 0.540428755894551 0.546550506828810 0.545342239528226 0.535609600905762 0.538357468353978 0.542470960564811 0.547216858334304 0.536714558679880 0.539181981937455 0.544833324438462 0.546534577352956 0.533727366801747 0.538824547931137 0.541912712936727 0.544108344066622 0.534124949670475 0.540184805521362 0.544411194256686 0.533669019561644];

    [Steps SampleSize]=size(Data);
     TrimmedMean=zeros(Steps,1);
     CovariancesOfTrimmedMean=zeros(Steps,2,2);
     if SampleSize>1&&trimmingPercentage==52
        if SampleSize<101
            correctionValue=correctionValues52(SampleSize-1);
        else
            correctionValue=(1-trimmingPercentage/100);
        end
     else
         correctionValue=(1-trimmingPercentage/100);
     end
     for i=1:1:Steps
         DataStep=Data(i,:);
       [TrimmedMean(i) CovariancesOfTrimmedMean(i,:,:)]=meanTrimmer(DataStep,trimmingPercentage);
     end 
     CovariancesOfTrimmedMean=reshape(CovariancesOfTrimmedMean,Steps,2,2)/correctionValue^2;
     if SampleSize==1
         CovariancesOfTrimmedMean=ones(Steps,2,2);
     end
end

function [TrimmedMean CovariancesOfTrimmedMean]=meanTrimmer(Data,trimmingPercentage)
%meanTrimmer - takes an array of complex measurements for the SAME
%datapoint and computes the trimmed Mean and its covariance. Values are
% ordered by their magnitude.
     SampleSize=length(Data);
    NumberOfValuesTrimmedEachSide=floor((SampleSize)*(trimmingPercentage./100.0)/2.0);
    OrderedData=sort(Data);
    LengthOfTrimmedData=SampleSize-2*NumberOfValuesTrimmedEachSide;
    TrimmedData=OrderedData(1+NumberOfValuesTrimmedEachSide:end-NumberOfValuesTrimmedEachSide);
    %ordering
    
     TrimmedMean=mean(TrimmedData);
     degreesOfFreedom=(LengthOfTrimmedData-2);
    
     if degreesOfFreedom<1
         degreesOfFreedom=1;
     end
    CovariancesOfTrimmedMean=cov([real(TrimmedData).' imag(TrimmedData).'])/degreesOfFreedom;
     %Covariances=Covariances.'/(SampleSize)
end