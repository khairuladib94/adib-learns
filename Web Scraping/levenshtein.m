function score = levenshtein(s1, s2, varargin)
%LEVENSHTEIN computes Levenshtein distance between two strings
%   this metric is used to determine the dissimilarity between sequences
%   optional parameters are:
%    - ratio: returns match ratio rather than distance
%    - ignorecase: ignores cass (case insensitive)
%    - ignoreorder: ignores word order
%    - partial: matches substring

% parse input arguments
returnRatio = false;                                    % default is false
ignoreCase = false;                                     % default is false
ignoreOrder = false;                                    % default is false
usePartial = false;                                     % default is false
if nargin < 2, error('Insufficient number of input arguments.'); end;
if ~any(ischar([s1 s2]) | isstring([s1 s2])), error('Non-string input arguments used.'); end;
if strlength(s1) == 0, error('Empty string us used.'); end;
if ~iscellstr(varargin), error('Non-string input arguments used.'); end;
if nargin > 2                                           % contains varargin
    if any(ismember(lower(varargin),'ratio'))           % ratio is specified
        returnRatio = true;                             % set flag to true
    end
    if any(ismember(lower(varargin),'ignorecase'))      % ignorecase is specified
        ignoreCase = true;                              % set flag to true
    end
    if any(ismember(lower(varargin),'ignoreorder'))     % ignoreorder is specified
        ignoreOrder = true;                             % set flag to true
    end
    if any(ismember(lower(varargin),'partial'))         % partial is specified
        usePartial = true;                              % set flag to true
    end
    if ~any(ismember(lower(varargin),{'ratio','ignorecase','partial'}))
        error('Unknown input arguments.');
    end
end

if ignoreCase                                           % if ignore case
    s1 = lower(s1);                                     % lowercase s1
    s2 = lower(s2);                                     % lowercase s2
end

if ignoreOrder                                          % if ignore order
    t1 = split(s1);                                     % tokenize
    t2 = split(s2);                                     % tokenize
    common = intersect(t1,t2);                          % intersection
    t1 = [common; setdiff(t1,common)];                  % common + diff
    t2 = [common; setdiff(t2,common)];                  % common + diff
    s1 = join(t1);                                      % join tokens
    s2 = join(t2);                                      % join tokens
end

s1 = char(s1);                                          % convert to char
s2 = char(s2);                                          % convert to char

if usePartial                                           % partial match
    if length(s1) > length(s2)                          % check length
        long = s1;                                      % s1 is longer
        short = s2;                                     % s2 is longer
    else
        long = s2;                                      % s2 is longer
        short = s1;                                     % s1 is longer
    end
    substr = getSubstrings(long, length(short));        % get substrings
    sumlengths = length(short) + strlength(substr);     % sum of lengths
    d = arrayfun(@(x)computeDistance(short,x), substr); % get distance
    r = (sumlengths - d)./sumlengths;                   % get ratio
    [d,idx] = min(d);                                   % find minimum d
    r = r(idx);                                         % matching ratio
else                                                    % full string match
    sumlengths = length([s1, s2]);                      % sum of lengths
    if isempty(s2)                                      % if s2 is empty
        d = length(s1);                                 % use s1 length
        r = 0;                                          % use zero
    else
        d = computeDistance(s1,s2);                     % get distance
        r = (sumlengths - d)/sumlengths;                % get ratio
    end
end

if returnRatio                                          % if flag is true
    score = r;                                          % return ratio
else                                                    % else
    score = d;                                          % distance
end

end

% Local functions
function d = computeDistance(s1,s2)
% COMPUTEDISTANCE returns Levenshtein distance

s1 = char(s1);                                      % convert to char
s2 = char(s2);                                      % convert to char
cost = 1;                                           % delete and insert cost
sub = 1;                                            % substitution cost

% initialize the grid with extra row and column for null strings
D = zeros(length(s1)+1, length(s2)+1);              % add extra row and column
D(:,1) = 0:length(s1);                              % the null string
D(1,:) = 0:length(s2);                              % the null string

% loop through a pair of characters
for ii = 2:size(D, 1)                               % skip the null row
    for j = 2:size(D, 2)                            % skip the null col
        deletion = D(ii-1, j) + cost;               % compute deletion cost
        insertion = D(ii, j-1) + cost;              % compute insertion cost
        if s1(ii-1) == s2(j-1)                      % if the same character
            substitution = D(ii-1, j-1) + 0;        % no substitution cost 
        else
            substitution = D(ii-1, j-1) + sub;      % compute substitution cost
        end
        D(ii,j) = min([deletion, insertion,...      % use the minimum of three
            substitution]);    
    end
end
% finish the computation
d = D(end);                                         % get distance

end

function substr = getSubstrings(str, len)
% GETSUBSTRINGS returns fixed-length subtrings from a string
substr = strings(length(str)-len + 1,1);            % initialize accumulator

% create a fixed- length substrings
for ii = 1:length(str)-len + 1                      % slide by 1 char
    seq = string(str(ii:ii+len-1));                 % extract substring
    substr(ii) = seq;                               % add to accumulator
end
    
end