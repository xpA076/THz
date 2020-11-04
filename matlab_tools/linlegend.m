% 通过数值向量添加图例
function linLegend(varargin)
%% 输入参数个数:
% 1 : numVector
% 2 : prefix, numVector
% 3 : prefix, numVector, suffix
narginchk(1,3);
prefix = '';
suffix = '';
numVec = [];
if (nargin == 1)
    numVec = varargin{1};
elseif (nargin == 2)
    prefix = varargin{1};
    numVec = varargin{2};
elseif (nargin == 3)
    prefix = varargin{1};
    numVec = varargin{2};
    suffix = varargin{3};
end
%% num to str
strVec = [];
for i = 1:length(numVec)
    strVec = [
        string(strVec);
        [prefix, num2str(numVec(i)), suffix]
    ];
end
%% draw legend
legend(strVec)
end