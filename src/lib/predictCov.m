function Snew = predictCov(x1, x2, S, Q)

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

dx = x2 - x1;
h = atan2(dx(2),dx(1));
sh = sin(h);
ch = cos(h);

% Jacobian
F = [1, 0, -sh*dx(1) - ch*dx(2);
     0, 1, ch*dx(1) - sh*dx(2);
     0, 0, 1];
   
W = [ch, -sh, 0;
     sh, ch, 0;
     0, 0, 1];

Snew = F * S * F' + W * Q * W';