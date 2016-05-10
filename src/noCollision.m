function s = noCollision(x, t, map)

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

% s = 0 --> collision
dx = t - x;
r_max = sqrt(dx(1)^2 + dx(2)^2);
res = .4 * map.gridSize;
dist = 0;
s = 1;
while dist < r_max
    dist = dist + res;
    q = x + dist * dx;
    [~, d_n] = knnsearch(map.mdl, q);
    if d_n <= 4*map.gridSize
        s = 0;
        return
    end
end