function [UBI, z_hits, newMap, varargout] = infoMIUB(currentPose, map)

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

param = map.param;
psat = map.param.psat;
hsat = map.param.hsat;
b_free = map.param.b_free;
b_occ = map.param.b_occ;
UBI = 0;

[beams, PF, z_hits] = rayCasting([currentPose 0], param, map);

for k = 1:size(beams,1)
    if ~(size(PF{k},1) > 1)
        continue;
    end
    htot = sum(entropyMap(PF{k}(:,1)));
    UBI = UBI + htot;
    d_list = PF{k}(:,2);
    for l = 1:size(PF{k},1)
        hm = entropyMap(map.prob(PF{k}(l,3)));
        if hm < hsat
            UBI = UBI - hm;
            continue;
        end      
        for zi = param.int_res:param.int_res:beams(k,1)
            [~,step] = min(abs(zi-d_list));
            
            if map.prob(PF{k}(step,3)) < param.prob_free
                map.prob(PF{k}(step,3)) = max(psat - 1e-3, b_free*map.prob(PF{k}(step,3)));
            else
                map.prob(PF{k}(step,3)) = min(1 - psat + 1e-3, b_occ*map.prob(PF{k}(step,3)));
            end
        end 
    end
end
newMap = map;
varargout{1} = [];