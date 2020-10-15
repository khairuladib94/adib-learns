% load('D:\OneDrive - Universiti Kebangsaan Malaysia\Penerbitan\Universe 2020 (Regular Issue)\Processed data\GMBLData.mat');
N = GMBL.A08{9}.MagN;
E = GMBL.A08{9}.MagE;
Z = GMBL.A08{9}.MagZ;
F = sqrt(N.^2 + E.^2 + Z.^2);
t = ( datetime : seconds(1) : datetime+(length(Z)-1)*seconds(1) )';
GMtable = timetable(N, E, Z, F, 'RowTimes', t);
%%
clc
Timer = timer('BusyMode', 'queue', 'ExecutionMode', 'fixedrate',...
    'Period', 30, 'StartFcn', @dispmessage, 'TimerFcn', {@sendGM2TS, GMtable}, 'TasksToExecute', 1000,...
    'ErrorFcn', @stopGM2TS);

start(Timer);

function dispmessage(~, ~)
fprintf('Data streaming to ThingSpeak has started at %s\n', datetime);
end

function sendGM2TS(Timer, ~, GMtable)
i = Timer.TasksExecuted;
Idx = 1+(i-1)*30 : (i-1)*30+30;
thingSpeakWrite(1168421, GMtable(Idx, 1:4), 'WriteKey', '3UAE7H5T558SOQB4');
fprintf('Data sent at %s\n', datetime);
end

function stopGM2TS(Timer, ~)
warning('Error!');
stop(Timer);
end