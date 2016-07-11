function [beams, PF, z_hits] = rayCasting(qi, param, map)
% This is a simple ray casting function to predict range measurements.
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

angRange = [-pi,pi]; % 360 deg perception field
nbeams = param.nbeams;
maxDist = param.Z_max;

% Compute maxRange point in local coordinates (robot frame)
dR = repmat(maxDist, 1, nbeams);
a = angRange(1):(angRange(2)-angRange(1))/(nbeams-1):angRange(2);
xmax_local = dR.*cos(a);
ymax_local = dR.*sin(a);

% Transform every maximum Beam into global coordinates
xmax_global = zeros(nbeams,1);
ymax_global = zeros(nbeams,1); 
for i = 1:nbeams
    % only when orientation is zero
    xmax_global(i) = qi(1) + xmax_local(i);
    ymax_global(i) = qi(2) + ymax_local(i);
end

nsteps = ceil(maxDist/param.resolution);
beams = zeros(nbeams,1);
PF = cell(nbeams,1);
z_hits = [];

for i = 1:nbeams
    idxSet = [];
    qj = [xmax_global(i); ymax_global(i)]; 
    dx = (qj(1)-qi(1)) / nsteps;
    dy = (qj(2)-qi(2)) / nsteps;
    r0 = sqrt(dx^2 + dy^2);
    for k = 1:nsteps
        q_test =[qi(1)+k*dx, qi(2)+k*dy];
        r_q = k * r0;
        [id_n, ~] = knnsearch(map.occMap, q_test);
        pc = map.prob(id_n);
        idxSet = [idxSet; pc, r_q, id_n];
        if pc > param.prob_occ
            beams(i) = r_q;
            zi = q_test';
            break;
        elseif k == nsteps
            zi = [];
            beams(i) = maxDist;
            break;
        end
    end
    PF{i} = idxSet;
    z_hits = [z_hits, zi];    
end