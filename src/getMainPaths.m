function P = getMainPaths(G)

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

path = getAllPaths2root(G.E, G.leaves);
p = [];
n = length(path.l);
t = ceil(.4*path.maxL);
k = 1;
l = [];
for i = 1:n
    if path.l(i) > t
        p{k,1} = path.p{i,1};
        l(k,1) = path.l(i);
        k = k + 1;
    end
end

n = length(p);
vote = zeros(n,1);
for i = 1:n-1
    pi = p{i,1};
    for j = i+1:n
        pj = p{j,1};
        len = min(l(i), l(j));
        s = sum(double(pi(1:len) == pj(1:len)));
        if (s/len) > .6
            if l(i) > l(j)
                vote(i) = vote(i) + 1;
                vote(j) = vote(j) - 1;
            else
                vote(i) = vote(i) - 1;
                vote(j) = vote(j) + 1;
            end
        else
            vote(i) = vote(i) + 1;
            vote(j) = vote(j) + 1;
        end
    end
end

m = max(vote);
id = find(vote == m);
P = [];
for i = 1:length(id)
    P{i,1} = p{id(i)};
end
        

