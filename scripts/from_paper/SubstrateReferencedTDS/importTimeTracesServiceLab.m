function allTimeTraces=importTimeTracesServiceLab(filePath,fileList)
%importTimeTracesServiceLab - imports all time traces from file List. 
%
% Syntax:  allTimeTraces=importTimeTracesServiceLab(filePath,fileList)
%
% Inputs:
%    filePath - the path to the folder, where the files are located
%       Structure: 'pathname' (string)
%    fileList - the list of all timeTrace files in folder 'pathname'
%       Structure: struct array
%              
%            .name            filename [String]
%            .timeWindow      duration of measured intervall [ps]
%            .timeStep        duration of step [ps]
%            .scans           number of scans repeated [int]
%            .sample          sample name [string]                      
%    
%
% Output:
%    allTimeTraces - the timetraces loaded 
%       Structure: cell array {[time trace1 ... tracen],traces from file 2,...}  time units: [ps]
%
%     
    allTimeTraces=cell(0);
    for l=1:length(fileList)
        fullMeasurementName=fullfile(filePath,fileList(l).name);
        timeWindow=fileList(l).timeWindow;
        timeStep=fileList(l).timeStep;
        sampleName=fileList(l).sample;
        nScans=fileList(l).scans;
        nSteps=timeWindow/timeStep; %number of timesteps per scan
        
        isDat=regexp(fileList(l).name, regexptranslate('wildcard','*.dat'));
        if isDat
            headerLines=15;
            rawData=dlmread(fullMeasurementName,'',[headerLines 0 headerLines+nSteps-1 1]);
        else
            headerLines=3;
            rawData=dlmread(fullMeasurementName,'',[headerLines 0 headerLines+nSteps-2 1]);
        end
     
        for k=2:nScans
            start=headerLines+(nSteps+5)*(k-1);
            ende=headerLines+(nSteps+5)*(k-1)+nSteps-2;
            rawData=[rawData dlmread(fullMeasurementName,'',[start 1 ende 1])];
%             test=dlmread(fullMeasurementName,'',[start 0 ende 1]);
%             a=test(1,1)
%             b=test(end,1)
        end

%         [rows columns]=size(rawData);
%        
%         if columns>1;
%             time=rawData(:,1); %reads the time array
%         else
%             time=timeStep:timeStep:timeWindow; %sets the time array
%         end
%         clear measuredTimeTraces  %the 'alldata' array contains the entire output
%         %     measuredTimeTraces=zeros(nScans,nSteps);
%         measuredTimeTraces(:,1)=time;  %first field is time
%         for i = 1:(columns-1) %And here the sample fields are filled in
%             start=(i-1)*rows+1
%             ende=i*rows
%             measuredTimeTraces(:,i+1)=rawData(start:ende);
%         end
        allTimeTraces{l}=rawData;
    end
end