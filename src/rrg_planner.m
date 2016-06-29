function out = rrg_planner()

%{  
    Copyright (C) 2016  Maani Ghaffari Jadidi
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details. 
%}

D = 20;
map = image2gridMap('cave.pgm', D/100);

MoreObstacles = [repmat(D,101,1), (0:D/100:D)';
                 zeros(101,1), (0:D/100:D)';
                 (0:D/100:D)', repmat(D,101,1);
                 (0:D/100:D)', zeros(101,1)];

map.obstacles = [map.obstacles ; MoreObstacles];
map.gridSize = D/100;
map.mdl = KDTreeSearcher(map.obstacles);

x = (-1:map.gridSize:21)';
y = (-1:map.gridSize:21)';
[X,Y] = meshgrid(x, y);
t = [X(:), Y(:)];
map.occMap = KDTreeSearcher(t);
map.prob = .5 * ones(size(t,1),1);
for i = 1:size(t,1)
    [~, d_n] = knnsearch(map.mdl, map.occMap.X(i,:));
    if d_n < .5*map.gridSize
        map.prob(i) = 0.85;
    else
        map.prob(i) = 0.3;
    end
end

map.param.prob_free = 0.35;
map.param.prob_occ = 0.65;

map.XTick = [0 5 10 15 20];
map.YTick = [0 5 10 15 20];

showGridMap(map)
hold on

x_init = [10,2];

t0 = tic;
G = RRG(map, x_init);
time = toc(t0);

out = [];
out.G = G;
out.time = time;
out.x_init = x_init;
out.map = map;