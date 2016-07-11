function P = getMaxInfoPath(G)

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

if isfield(G,'path')
    path = G.path;
else
    path = getMainPaths(G);
end

P = path{1};
I = sum(G.Einfo(P));
n = length(path);
if n > 1
    for i = 2:n
        Ii = sum(G.Einfo(path{i}));
        if Ii > I
            P = path{i};
            I = Ii;
        end
    end
end
