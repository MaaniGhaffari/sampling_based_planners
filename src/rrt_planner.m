function G = rrt_planner()

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

showGridMap(map)
hold on

x_init = [10,2];
G = RRT(map, x_init);

