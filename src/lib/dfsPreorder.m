function [path, leaves] = dfsPreorder(G)

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

s = [];
node = 1;
visited = zeros(size(G.V.X,1),1);
leaves = [];
k = 1;
while (~isempty(s) || ~isempty(node))
    if ~isempty(node)
        visited(node) = k;
        k = k + 1;
        c = childNodes(G.E, node);
        if ~isempty(c)
            if length(c) > 1
                s = [s; c(2:end)]; % s.push
                node = c(1);
            else
                node = c(1);
            end
        else
            leaves = [leaves; node];
            node = [];
        end
    else
        node = s(end);
        s(end) = []; % s.pop
    end
end

[~, path] = sort(visited, 'ascend');




