load('D:\OneDrive - Universiti Kebangsaan Malaysia\Penerbitan\Research paper 2020\Processed data\GMBL.mat');

N = GMBL.A08{9}.MagN;
E = GMBL.A08{9}.MagE;
Z = GMBL.A08{9}.MagZ;
t = GMBL.UTC{9}.MinuteInYear;
tt = timetable(N,E,Z, 'RowTimes', t);
j = 1;
for i = 1:30
    thingSpeakWrite(1168421, tt(j:j+14,1), 'WriteKey', '3UAE7H5T558SOQB4');
    j = j + 15;
    pause(15);
end