function [fp, yp] = scanLineSegmentationLocal(laserScan)
% This function divides range measurments lines to smaller segments.
%
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

nStates = length(laserScan);
yp = cell(size(laserScan));
fp = cell(size(laserScan));
Nmin = 1; % if laserScan is empty
for i = 1:nStates
    for j = 1:size(laserScan{i},2)
        Nmin = ceil(6.25 * sqrt(laserScan{i}(1,j).^2 + laserScan{i}(2,j).^2));
        Nmin = min(Nmin,15);
        fp{i}(:,j) = [laserScan{i}(1,j); laserScan{i}(2,j)] * 1/Nmin;
        yp{i}(j,1) = 1; % target value for occupancy mapping
    end
    
    for m = 1:Nmin-2
        k = m*size(laserScan{i},2)+1:(m+1)*size(laserScan{i},2);
        for j = 1:size(laserScan{i},2)
            fp{i}(:,k(j)) = [laserScan{i}(1,j); laserScan{i}(2,j)] * (m+1)/Nmin;
            yp{i}(k(j),1) = 1;  % target value for occupancy mapping
        end
    end
end