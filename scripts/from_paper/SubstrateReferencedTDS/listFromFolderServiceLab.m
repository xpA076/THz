function [fileList]=listFromFolderServiceLab(filePath)
%listFromFolder - reads all file names in and extracts the measurement 
%parameters
%WILL ONLY WORK IF FILES IN FOLDER ARE EXCLUSIVELY Time timestep averages
%
% Syntax:  [fileList]=listFromFolder(filePath)
%
% Inputs:
%    filePath - the path to the folder, where the files are located
%       Structure: 'pathname' (string)
%
% Output:
%    fileList - struct array with:
%            .name            filename [String]
%            .timeWindow      duration of measured intervall [ps]
%            .timeStep        duration of step [ps]
%            .scans           number of scans repeated [int]
%            .sample          sample name [string]
%            .date            date of creation name [string]
%

    folderContents=dir(filePath);
    [nElement dummie]=size(folderContents);
    nFile=nElement-2;
    timeWindow=[]*nFile;
    timeStep=[];
    fileList=struct([]*nFile);

     for i=1:1:nFile
         fileList(i).name=folderContents(i+2).name;
         splittedStrings=splitstring(fileList(i).name,' ');
         
         
%          timeWindow=cellstr(char(splittedStrings(end-1))); %get scan duration from file name
%          timeWindow=regexp(timeWindow,'[0-9]+','match');
%          timeWindow=str2num(char(timeWindow{1}));
         timeWindow=20;
         
%          timeStep=cellstr(char(splittedStrings(end))); %get time step from file name
%          timeStep=regexp(timeStep,'[0-9]+','match');
%          timeStep=str2num(char(timeStep{1}))/100;
         timeStep=0.05;
         
%          txt=fileread(fullfile(filePath,folderContents(i+2).name)); %Compute number of Scans
%          nLines=sum(txt==10)+1;
%           nStepsPerScan=timeWindow/timeStep;
%          nScans=floor((nLines-3-nStepsPerScan)/(nStepsPerScan+4))+1;
%          if nScans <=0
%              warning(strcat('file ',fileList(i).name,' is an incomplete scan'));
%              nScans=0;
%          end
         nScans=1;
         fileList(i).timeWindow=timeWindow;
         fileList(i).timeStep=timeStep;
         fileList(i).scans=nScans;
         fileList(i).sample=splittedStrings(1);
         fileList(i).date=folderContents(i+2).date;
     end

end

function rv = splitstring( str, varargin )
%SPLITSTRING Split string into cell array
%    ARRAY = SPLITSTRING( STR, DELIM, ALLOWEMPTYENTRIES ) splits the
%    character string STR, using the delimiter DELIM (which must be a
%    character array). ARRAY is a cell array containing the resulting
%    strings. If DELIM is not specified, space delimiter is assumed (see
%    ISSPACE documentation). ALLOWEMPTYENTRIES should be a logical single
%    element, specifying weather empty elements should be included in the
%    results. If not specified, the value of ALLOWEMPTYENTRIES is false.
%
%    Example:
%         arr = splitstring( 'a,b,c,d', ',' )

delim = '';
AllowEmptyEntries = false;

if numel(varargin) == 2
        delim = varargin{1};
        AllowEmptyEntries = varargin{2};
elseif numel(varargin) == 1
        if islogical(varargin{1})
                AllowEmptyEntries = varargin{1};
        else
                delim = varargin{1};
        end
end

if isempty(delim)
        delim = ' ';
        ind = find( isspace( str ) );
else
        ind = strfind( str, delim );
end

startpos = [1, ind+length(delim)];
endpos = [ind-1, length(str)];

rv = cell( 1, length(startpos) );
    for i=1:length(startpos)
        rv{i} = str(startpos(i):endpos(i));
    end

if ~AllowEmptyEntries
        rv = rv( ~strcmp(rv,'') );
end

end