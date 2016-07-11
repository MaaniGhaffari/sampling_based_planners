function [G, varargout] = IIG(map, x_init, infoFunc, varargin)

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

% Initialize cost, information, starting node, node list, edge list, and tree
if nargin > 3
    plot_opt = varargin{1};
end

G = [];
G.infoFunc = func2str(infoFunc);
ns = 0;
delta  = 2.5*map.gridSize;
B = 1e5; % Budget
V = x_init;
G.V = KDTreeSearcher(V);
G.E = [];
G.C = 0;
C = 0;
if ~isempty(map.Sigma)
    I = infoFunc(x_init, map, map.Sigma);
    G.S = cell(1,1);
    G.S{1} = map.Sigma;
    Q = map.Q;
else
    I = infoFunc(x_init, map);
end
G.I = I;
G.closed = 0;
G.Ecost = 0;
G.Einfo = 0;
closed = 0;
I_RIC = 0;
Itot = 0;
UBtot = 0;
RIC = [];

green = [0.2980 .6 0];
orange = [1 .5 0];
darkblue = [0 .2 .4];
Darkgrey = [.25 .25 .25];
darkgrey = [.35 .35 .35];
lightgrey = [.7 .7 .7];
Lightgrey = [.9 .9 .9];
fsize = 20;

if plot_opt
    plot(x_init(1), x_init(2), 's', 'markersize',12, 'Color', green, 'MarkerFaceColor', green)
    set(gca, 'XTick', map.XTick);
    set(gca, 'YTick', map.YTick);
end
conv_window = 30;
cont = 1;
iter = 0;
step = 1;
if isfield(map,'prob')
    idx = find(map.prob < map.param.prob_free);
else
    idx = (1:map.size(1))';
end
while cont > map.delta_ric
    iter = iter + 1;
    % Sample configuration space of vehicle and find nearest node
    x_samp = sampleFree(map,idx);
    ns = ns + 1;
    [id_nearest, ~] = knnsearch(G.V, x_samp);
    if G.closed(id_nearest)
        continue
    else
        x_nearest = G.V.X(id_nearest,:);
    end
    [x_feasible, valid] = steer(x_nearest, x_samp, delta);
    if ~valid
        continue
    end
    % Find near points to be extented
    [Idx, ~] = rangesearch(G.V, x_feasible, 6); % 30 for wifi
    Idx = Idx{1};
    Iave = [];
    if ~isempty(Idx)
        for j = 1:length(Idx)
            if G.closed(Idx(j))
                continue
            else
                % Extend towards new point
                [x_new, valid] = steer(G.V.X(Idx(j),:), x_feasible, delta);
                if ~valid
                    continue                                      
                elseif noCollision(G.V.X(Idx(j),:), x_new, map)
                    % Calculate new inormation and cost                    
                    Ce = costLine(G.V.X(Idx(j),:), x_new);
                    Cnew = G.C(Idx(j)) + Ce; 
                    if ~isempty(map.Sigma)
                        S = predictCov(G.V.X(Idx(j),:), x_new, G.S{Idx(j)}, Q);
                        [Ie, z_hits, map, UBI] = infoFunc(x_new, map, S);
                    else
                        [Ie, z_hits, map, UBI] = infoFunc(x_new, map);
                    end
                    Iave = [Iave; Ie];
                    p = parentNode(G.E, Idx(j));
                    Inew = Ie + G.I(p);
                    if ~isempty(UBI)
                        UBI = UBI + G.I(p);
                    end
                    if (Inew/G.I(Idx(j)) < 1) && (Cnew > G.C(Idx(j)))
                        continue
                    else
                        RIC =  [RIC; (Inew/G.I(Idx(j)) - 1) / ns];
                        I_RIC(end+1) = I_RIC(end) + RIC(end);
                        step = step + 1;
                        if ~isempty(UBI)
                            UBtot(end+1) = UBtot(end) + (UBI/G.I(Idx(j)) - 1) / ns; 
                        end
                        ns = 0;
                        V = [V; x_new];
                        G.V = KDTreeSearcher(V);
                        G.E = [G.E; Idx(j) size(G.V.X,1)];
                        C = [C; Cnew];
                        G.C = C; 
                        I = [I; Inew];
                        G.I = I;
                        G.Einfo = [G.Einfo; Ie];
                        G.Ecost = [G.Ecost; Ce];
                        if ~isempty(map.Sigma)
                            G.S{end+1,1} = S;
                        end
                        if plot_opt
                            x_near = G.V.X(Idx(j),:);
                            line([x_near(1) x_new(1)], [x_near(2) x_new(2)], 'Color', lightgrey, 'linewidth', 2)
                            plot(x_new(1), x_new(2), '.', 'MarkerSize', 10, 'Color', darkgrey)
                            if ~isempty(map.Sigma)
                                ell = getEllipse(x_new, S);
                                line(ell(1,:), ell(2,:), 'Color', Lightgrey, 'linewidth', 0.5)
                            end
                        end
                        if Cnew > B
                            closed = [closed; 1];
                            G.closed = closed;
                        else
                            closed = [closed; 0];
                            G.closed = closed;
                        end
                        if length(RIC) > conv_window
                            cont = mean(RIC(end-conv_window:end));
                        end
                    end
                    break
                end
            end
        end
    end  
    if ~isempty(Iave)
        Itot(iter) = mean(Iave);
    else
        Itot(iter) = 0;
    end
end

[path, leaves] = dfsPreorder(G);
G.dfs = path;
G.leaves = leaves;
P = getMainPaths(G);
Pmax = getMaxInfoPath(G);
if plot_opt
    for i = 1:length(P)
        plotPath(G.V.X, P{i})
    end
    plotPath(G.V.X, Pmax, Darkgrey, 4)
    for i = 1:length(P)
        plot(G.V.X(P{i}(end),1), G.V.X(P{i}(end),2), '.r', 'MarkerSize', 16)
    end
    plot(x_init(1), x_init(2), 's', 'markersize',14, 'Color', green, 'MarkerFaceColor', green)

    figure(2); hold on
    plot(1:step, I_RIC, '-', 'linewidth',3, 'Color', darkblue)
    if ~isempty(UBI)
        plot(1:step, UBtot, '-', 'linewidth',3, 'Color', green)
        legend('RIC', 'UBRIC', 'location','best')
    end
    axis auto, axis square, axis tight, grid on
    set(gca,'fontsize', fsize)
    xlabel('Number of nodes','Interpreter','LaTex')
    ylabel('I$_{RIC}$','Interpreter','LaTex')

    figure(3); hold on
    plot(1:iter, Itot, '-', 'linewidth',2, 'Color', darkblue)
    axis auto, axis square, axis tight, grid on
    set(gca,'fontsize', fsize)
    xlabel('Number of samples','Interpreter','LaTex')
    ylabel('MI (NATS)','Interpreter','LaTex')
end

G.path = P;
G.maxInfoPath = Pmax;
G.step = step;
G.iter = iter;
G.I_RIC = I_RIC;
G.Itot = Itot;
G.UBtot = UBtot;
if nargout > 1
    varargout{1} = map;
end