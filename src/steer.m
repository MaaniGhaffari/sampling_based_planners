function [p2, valid] = steer(p1, wps, delta)

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

x = wps(1,1);
y = wps(1,2);
theta = atan2(y - p1(2), x - p1(1));
r = sqrt((x - p1(1))^2 + (y - p1(2))^2);
if r < 2 * delta
    valid = 0;
    p2 = [];
    return
else
    r = r * delta;
    valid = 1;
end

x = r * cos(theta) + p1(1);
y = r * sin(theta) + p1(2);
p2 = [x, y];
