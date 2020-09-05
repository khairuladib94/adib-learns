%% Map 1: Roads using graphical data structure
roads = shaperead('concord_roads.shp');     % .shp file is a geospatial vector data format for GIS software
figure;
mapshow(roads);
xlabel('Eastward in metre');
ylabel('Northward in metre');
%% Map 2: Roads with custom LineStyle
figure;
mapshow('concord_roads.shp', 'LineStyle', ':');
xlabel('Eastward in metre');
ylabel('Northward in metre');
%% Map 3: Roads with SymbolSpec
type concord_roads.txt      % Description of the map data

roads = shaperead('concord_roads.shp');

histcounts([roads.CLASS], 'BinLimits', [1 7], 'BinMethod', 'integer')

histcounts([roads.ADMIN_TYPE], 'BinLimits', [0 3], 'BinMethod', 'integer')

roadspec = makesymbolspec('Line',...
    {'Default', 'Color', 'green'},...
    {'ADMIN_TYPE', 0, 'Color', 'black'},...
    {'ADMIN_TYPE', 3, 'Color', 'red'},...
    {'CLASS', [5 6], 'Visible', 'off'},...
    {'CLASS', [1 4], 'LineWidth', 2});

figure
mapshow('boston_roads.shp', 'SymbolSpec', roadspec);
xlabel('Eastward in metre');
ylabel('Northward in metre');
%% Map 4: GeoTIFF image of Boston
figure;
mapshow boston.tif
axis image manual off

S = shaperead('boston_placenames.shp');

SurveyFeetPerMeter = unitsratio('sf', 'meter');
for k = 1:numel(S)
    S(k).X = SurveyFeetPerMeter*S(k).X;
    S(k).Y = SurveyFeetPerMeter*S(k).Y;
end

text([S.X], [S.Y], {S.NAME}, 'Color', [0 0 0], ...
    'BackgroundColor', [0.9 0.9 0], 'Clipping', 'on');






