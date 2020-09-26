function GM = readMAGDAS(StartDate, EndDate, StnCode, SamplingPeriod, FilePath, FileNameFormat, DataFormat, HeaderLine)

% This function reads MAGDAS geomagnetic field data
%
% Examples of input arguments
%
%   StartDate                = [2012, 01, 20]
%   EndDate                  = [2012, 01, 27]
%   StnCode                  = 'CEB'
%   SamplingPeriod (seconds) = 1
%   FilePath                 = 'D:\OneDrive\Belajar\Sandboxes\Learning\General\Raw data\'
%   FileNameFormat           = '%3s%04d%02d%02dpsec.sec'
%   DataFormat               = '%4d-%02d-%02d %02d:%02d:%02d.000 %3d %9.2f %9.2f %9.2f %9.2f'
%   HeaderLine               = 13
%
% Written by Adib Yusof (2020) | mkhairuladibmyusof@gmail.com

arguments
    StartDate (1,3) double
    EndDate (1,3) double
    StnCode (1,3) char
    SamplingPeriod (1,1) double
    FilePath (1,:) char
    FileNameFormat (1,:) char 
    DataFormat (1,:) char = '%4d-%02d-%02d %02d:%02d:%02d.000 %3d %9.2f %9.2f %9.2f %9.2f'
    HeaderLine (1,1) double = 13
end

UTC(:, 1) = datetime(StartDate) : seconds(SamplingPeriod) : datetime(EndDate) + days(1) - seconds(1);
[H, D, Z, F] = deal( NaN(numel(UTC), 1) );
DataIdx = 1;
IndxIncrement = (86400 / SamplingPeriod) - 1;

for i = datetime(StartDate) : datetime(EndDate)
    DateAsVector = datevec(i);
    FileName = sprintf(FileNameFormat, StnCode, DateAsVector);
    FullFilePath = [FilePath, FileName];
    FileID = fopen(FullFilePath);
    if FileID < 0
        continue;
    end
    
    disp(['Extracting ', FileName]);
    ExtractedData = textscan(FileID, DataFormat, 'HeaderLines', HeaderLine);
    [H(DataIdx:DataIdx+IndxIncrement), D(DataIdx:DataIdx+IndxIncrement), Z(DataIdx:DataIdx+IndxIncrement), F(DataIdx:DataIdx+IndxIncrement)] = ExtractedData{end-3:end};
    
    DataIdx = DataIdx + IndxIncrement + 1;
    fclose(FileID);
end

GM = table(UTC, H, D, Z, F);
GM.Properties.Description = [StnCode, ' data obtained from MAGDAS'];
end