function path = getAllPaths2root(E, leaves)

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

path = [];
n = length(leaves);
path.p = cell(n,1);
path.l = zeros(n,1);
for i = 1:n
    p = getPath2root(E, leaves(i));
    path.l(i) = length(p);
    path.p{i,1} = p;
end

path.maxL = max(path.l);