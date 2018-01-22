function []=plotXYY(xVector,yMatrix,parameterCell)

% Get the properties in either direct or P-V format
[~, pvPairs] = parseparams(parameterCell);

% Now process the optional P-V params
try
    % Initialize with default values
    paramName = [];
    paramsStruct.name = 'THz field transmission spectra';
    paramsStruct.xLabel = 'Frequency [THz]';
    paramsStruct.yLabel = 'Signal Amplitude [mV]';
  
    paramsStruct.xMin ='auto';
    paramsStruct.xMax ='auto';
    paramsStruct.yMin = 'auto';
    paramsStruct.yMax = 'auto';
    paramsStruct.legendEntries = 'auto';
 
    % other default params can be specified here
    
    supportedArgs = {'name','xLabel','yLabel',...
        'xMin','xMax','yMin','yMax',...
        'legendEntries','dividermaxlocation'};
    
    while ~isempty(pvPairs)
        
        % Ensure basic format is valid
        paramName = '';
        if ~ischar(pvPairs{1})
            error('invalidProperty','Invalid property');
        elseif length(pvPairs) == 1
            error('noPropertyValue',['No value specified for property ''' pvPairs{1} '''']);
        end
        
        % Process parameter values
        paramName  = pvPairs{1};
        paramValue = pvPairs{2};
        paramsStruct=setfield(paramsStruct,paramName,paramValue);
        pvPairs(1:2) = [];
        if ~any(strcmpi(paramName,supportedArgs))
            url = ['matlab:help ' mfilename];
            urlStr = getHtmlText(['' strrep(url,'matlab:','') '']);
            error('invalidProperty',...
                ['Unsupported property - type "' urlStr ...
                '" for a list of supported properties']);
        end
    end  % loop pvPairs
    
catch
    if ~isempty(paramName)
        paramName = [' ''' paramName ''''];
    end
    error('invalidProperty',['Error setting uisplitpane property' paramName ':' char(10) lasterr]);
end
% xVector=complexRefractiveIndex(:,1);
% y1Matrix=real(complexRefractiveIndex(:,2:end));
% y2YMatrix=imag(complexRefractiveIndex(:,2:end));
%  name='THz field transmission spectra';
%  xLabel='Frequency [THz]';
%  y1Label='Signal Amplitude [mV]';
%  y2Label='Phase [rad]';
name=paramsStruct.name;
xLabel=paramsStruct.xLabel;
y1Label=paramsStruct.yLabel;
legendEntries=paramsStruct.legendEntries;
scrsz = get(0,'ScreenSize');
xMin=paramsStruct.xMin;
xMax=paramsStruct.xMax;
y1Min=paramsStruct.yMin;
y1Max=paramsStruct.yMax;

outerPos=[1 scrsz(4)/3 scrsz(3)/2 scrsz(4)/1.5];

[nRows nColumns]=size(yMatrix);
xMatrix=zeros(nRows,nColumns);
colorTable=[];
for i=1:1:nColumns
    [R G B]=FloatToRGB(i./nColumns);
    colorTable=[colorTable',[R G B]']';
    xMatrix(:,i)=xVector;
end
figure1 = figure('Name',name,'Color',[1 1 1],'OuterPosition',outerPos);

% Create axes
axes1 = axes('Parent',figure1,...
    'XAxisLocation','bottom',...
    'Units','centimeters',...
    'OuterPosition',[0 0 35 20],...
    'LineWidth',2,...
    'FontSize',16);
% Uncomment the following line to preserve the X-limits of the axes
if (~strcmpi(xMin,'auto')) && (~strcmpi(xMax,'auto'))
    xlim(axes1,[xMin xMax]);
end
% Uncomment the following line to preserve the Y-limits of the axes

if (~strcmpi(y1Min,'auto')) && (~strcmpi(y1Max,'auto'))
    ylim(axes1,[y1Min y1Max]);
end
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(xMatrix,yMatrix,'Parent',axes1);
for i=1:nColumns
    set(plot1(i),'Color',colorTable(i,:));
end

% Create ylabel
ylabel(y1Label,'FontSize',26);

xlabel(xLabel,'FontSize',26);

% create legend
legend1 = legend(axes1,'show');
set(legend1,'Units','centimeters',...
    'Position',[20.7006407638889 5.01885717013891 3.29596590277776 7.77724574652776]);
if (~strcmpi(legendEntries,'auto'))
    set(legend1,'String',legendEntries)
end

end

function [red green blue]=FloatToRGB(Float)%colorfunction for float between 0 and 1
    if Float < 0
        red= 0;
        green=0;
        blue=0;
    elseif Float < 1./6
        red= 1;
        green=6*Float;
        blue=0;
    elseif Float < 2./6
        red=2-6*Float;
        green=1;
        blue=0;
    elseif Float < 3./6
        red=0;
        green=1;
        blue=6*Float-2;
    elseif Float < 4./6
        red=0;
        green=4-6*Float;
        blue=1;
    elseif Float < 5./6
        red=6*Float-4;
        green=0;
        blue=1;
    elseif Float <= 6./6
        red=1.0;
        green=0;
        blue=6-6*Float;
    else
        red=0.9;
        green=0.9;
        blue=0.9;
    end
end