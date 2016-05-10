function map = image2gridMap(imageName, gridSize)

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

% gridMap = [x, y, occupancy], size = numOfCells x 3

I = imread(imageName);
M = im2bw(I); 
[rows, cols] = size(M);
k = 1;
obstacles = [];
for i = rows:-1:1
    for j = 1:cols
        if M(i,j) == 1
            gridMap(k,:) = [gridSize*(j-1), gridSize*(rows-i), 0];
            k = k + 1;
        else
            obstacles = [obstacles; gridSize*(j-1), gridSize*(rows-i)];
            gridMap(k,:) = [gridSize*(j-1),gridSize*(rows-i), 1];  
            k = k + 1;            
        end
    end
end

map.obstacles = obstacles;
map.gridSize = gridSize;
