function plotPath(X, path)

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

colour = [161 80 8]/255;
for i = 1:length(path)-1
    x1 = X(path(i),:);
    x2 = X(path(i+1),:);
    line([x1(1) x2(1)], [x1(2) x2(2)], 'Color', colour, 'linewidth', 3)
end