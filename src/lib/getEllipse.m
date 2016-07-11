function e = getEllipse(m, S2d)

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

S2d = S2d(1:2,1:2);
% For 2 dim, Xi squared distribution with 90% confidence level: 
% sqrt(4.605) = 2.1459.
R = chol(S2d);
y = 2.1459*[cos(0:0.1:2*pi);sin(0:0.1:2*pi)];
el = R*y;
e = [el el(:,1)]+repmat(m(1:2)',1,size(el,2)+1);