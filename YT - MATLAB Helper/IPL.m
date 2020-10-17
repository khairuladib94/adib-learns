%% Description 
% Learning based on a YouTube video at: https://youtu.be/b0f7OBW5rUY
%% Extracting data from a webpage 
URL = 'https://www.iplt20.com/stats/2020/most-runs';
WebData = webread(URL);

SplitData = strsplit(WebData, '<tr class="js-row ');
SplitData = SplitData(2:end);

Info = {'Nationality', 'TeamID', 'Name', 'Match'};
PreDelim = {
    'data-nationality="', ...
    '<td class="top-players__freeze js-pos top-players__pos ',...
    'alt="',...
    '<td class="top-players__m top-players__padded ">\n',...
    };
PostDelim = {'"',...
    '"',...
    ' Headshot"',...
    '\n'};

for i = length(SplitData):-1:1
    Str = SplitData{i};
    for j = 1:length(Info)
        SplitStr = strsplit(Str, PreDelim{j});
        StrSplit = strsplit(SplitStr{2}, PostDelim{j});
        switch j
            case 3, Players(i).(Info{j}) = StrSplit{1};
            case 4, Players(i).(Info{j}) = str2double(StrSplit{1});
            otherwise, Players(i).(Info{j}) = categorical(StrSplit(1));
        end
    end
end