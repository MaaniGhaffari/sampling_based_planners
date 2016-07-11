function x_samp = sampleFree(map,varargin)

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

if nargin > 1 && nargin == 2
    idx = varargin{1};
    nf = length(idx);
else
    if isfield(map,'prob')
        idx = find(map.prob < map.param.prob_free);
    else
        idx = (1:map.size(1))';
    end
    nf = length(idx);
end
if isfield(map,'occMap')
    x_samp = map.occMap.X(idx(ceil(rand*nf)),:);
else
    x_samp = map.mdl.X(idx(ceil(rand*nf)),:);
end
