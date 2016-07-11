function H = entropyMap(M)

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

[m,n] = size(M);
H = zeros(m,n);

for i = 1:m
    for j = 1:n
        H(i,j) = -(M(i,j) * log(M(i,j)) + (1-M(i,j)) * log(1-M(i,j)));
    end
end