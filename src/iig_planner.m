function out = iig_planner(varargin)

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

predictUGPVR = false;
covfunc = {@covMaterniso, 5};
load('hyperparam')
if nargin > 0
        switch lower(varargin{1})
            case 'mi'
                info = @infoMI;
            case 'gpvr'
                info = @infoGPVR;
            case 'miub'
                info = @infoMIUB;
            case 'ugpvr'
                info = @infoUGPVR;
                predictUGPVR = true;
            otherwise
                warning('Information function default is MI.')
                info = @infoMI;
        end
else
    warning('Information function default is MI.')
    info = @infoMI;
end
if nargin > 1
    plot_opt = varargin{2};
else
    plot_opt = true;
end
if nargin > 2
    if strcmp(varargin{3},'beam')
        nbeams = varargin{4};
        Z_max = 5;
    elseif strcmp(varargin{3},'range')
        Z_max = varargin{4};
        nbeams = 10;
    end
else
    nbeams = 10;
    Z_max = 5;
end

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
map.ent = entropyMap(map.prob);
map.size = size(X);
map.Cov = ones(size(t,1),1);
map.covfunc = covfunc;
map.hyp = hyp;
map.delta_ric = 5e-3;

if predictUGPVR
    map.Sigma = [0.4^2,0,0; 0,0.1^2,0; 0,0,0];
    map.Q = [0.1^2,0,0; 0,0.1^2,0; 0,0,(0.15*pi/180)^2];
else
    map.Sigma = [];
end

map.param.prob_free = 0.35;
map.param.prob_occ = 0.65;
map.param.Z_max = Z_max;
map.param.resolution = .4 * map.gridSize;
map.param.nbeams = nbeams;
map.param.z_hit = .7;
map.param.z_rand = .1;
map.param.z_short = .1;
map.param.z_max = .1;
map.param.lambda_short = .2;
map.param.sigma_hit = 0.05;
map.param.gridSize = map.gridSize;
map.param.p_rand = double(1 / map.param.Z_max);
map.param.int_res = .5;
map.param.psat = 0.05;
map.param.hsat  = entropyMap(map.param.psat);
map.param.b_free = 0.6;
map.param.b_occ = 1.6667;

map.XTick = [0 5 10 15 20];
map.YTick = [0 5 10 15 20];

if plot_opt
    showGridMap(map)
    hold on
end

x_init = [10,2];

t0 = tic;
G = IIG(map, x_init, info, plot_opt);
time = toc(t0);

out = [];
out.G = G;
out.time = time;
out.delta_ric = map.delta_ric;
out.x_init = x_init;
out.map = map;