function G = RRTstar(map, x_init, varargin)

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

if nargin > 2
    nsteps = varargin{1};
else
    nsteps = 2000;
end

V = x_init;
G.V = KDTreeSearcher(V);
G.E = [];
G.C = 0;
C = 0;
G.closed = 0;
closed = 0;
delta  = 2.5*map.gridSize;

green = [0.2980 .6 0];
darkgrey = [.35 .35 .35];
lightgrey = [.7 .7 .7];

plot(x_init(1), x_init(2), 's', 'markersize',12, 'Color', green, 'MarkerFaceColor', green)
set(gca, 'XTick', map.XTick);
set(gca, 'YTick', map.YTick);
axis tight

idx = find(map.prob < map.param.prob_free);
for i = 1:nsteps
    x_rand = sampleFree(map,idx);
    [id_near, ~] = knnsearch(G.V, x_rand);
    x_near = G.V.X(id_near,:);
    [x_new, valid] = steer(x_near, x_rand, delta);
    if ~valid
        continue
    end

    if noCollision(x_near, x_new, map)
        [Idx, ~] = rangesearch(G.V, x_new, 6);
        Idx = Idx{1};
        if isempty(Idx)
            continue
        else
            V = [V; x_new];
            G.V = KDTreeSearcher(V);
            C = [C; G.C(id_near) + costLine(G.V.X(id_near,:), x_new)];
            G.C = C;
            closed = [closed; 0];
            G.closed = closed;
            id_new = size(G.V.X,1);
            plot(x_new(1), x_new(2), '.', 'MarkerSize', 10, 'Color', darkgrey)
            id_min = id_near; Cmin = G.C(id_near) + costLine(G.V.X(id_near,:), x_new);
            for j = 1:length(Idx)
                Cnear = G.C(Idx(j)) + costLine(G.V.X(Idx(j),:), x_new);
                if noCollision(G.V.X(Idx(j),:), x_new, map) && (Cnear < Cmin)
                    id_min =  Idx(j);
                    Cmin = Cnear;
                end
            end
            
            C(end) = Cmin;
            G.C = C;
            G.E = [G.E; id_min id_new];
            for j = 1:length(Idx)
                Cnear = G.C(id_new) + costLine(x_new, G.V.X(Idx(j),:));
                if noCollision(x_new, G.V.X(Idx(j),:), map) && (Cnear < G.C(Idx(j)))
                    [~, E] = parent(G.E, Idx(j));
                    G.E = E;
                    G.E = [G.E; id_new Idx(j)];
                end
            end
        end
    end
end

plotEdges(G,lightgrey)
[path, leaves] = dfsPreorder(G);
G.dfs = path;
G.leaves = leaves;
for i = 1:length(leaves)
    plot(G.V.X(leaves(i),1), G.V.X(leaves(i),2), '.r', 'MarkerSize', 16)
end

P = getMainPaths(G);
G.path = P;
for i = 1:length(P)
    plotPath(G.V.X, P{i})
end

plot(x_init(1), x_init(2), 's', 'markersize',12, 'Color', green, 'MarkerFaceColor', green)
