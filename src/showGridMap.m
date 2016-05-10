function showGridMap(map)

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

n_grids = size(map.obstacles,1);

for i = 1:n_grids 
    rectangle('Position',[map.obstacles(i,1), map.obstacles(i,2), map.gridSize, map.gridSize],'FaceColor',[0 .2 .4]);
end

axis equal
set(gca,'fontsize',20)