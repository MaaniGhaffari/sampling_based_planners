function [Itot, z_hits, newMap, varargout] = infoMI(currentPose, map)

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
Itot = 0;
UBI = 0;

[beams, PF, z_hits] = rayCasting([currentPose 0], param, map);

for k = 1:size(beams,1)
    if ~(size(PF{k},1) > 1)
        continue;
    end
    htot = sum(entropyMap(PF{k}(:,1)));
    UBI = UBI + htot;
    Itot = Itot + htot;
    d_list = PF{k}(:,2);
    pz_vec = d_list * 0;
    for l = 1:size(PF{k},1)
        hm = entropyMap(map.prob(PF{k}(l,3)));
        if hm < hsat
            Itot = Itot - hm;
            UBI = UBI - hm;
            continue;
        end
        Hc = 0;        
        for zi = param.int_res:param.int_res:beams(k,1)
            [~,step] = min(abs(zi-d_list));
            pz_vec = pz_vec*0;
            for i = 1:step
                pz_vec(i) = mixtureModelDensity(d_list(i), zi, param);
            end
            p1 = param.p_rand;
            p2 = 0;
            for ll = 1:step
                p1 = p1 * (1 - PF{k}(ll,1));
                p2 = p2 + pz_vec(ll) * PF{k}(ll,1) * prod(1-PF{k}(1:ll-1,1));
            end
            if map.prob(PF{k}(step,3)) < param.prob_free
                map.prob(PF{k}(step,3)) = max(psat - 1e-3, b_free * map.prob(PF{k}(step,3)));
            else
                map.prob(PF{k}(step,3)) = min(1 - psat + 1e-3, b_occ * map.prob(PF{k}(step,3)));
            end
            m_bar = map.prob(PF{k}(step,3));
            Hc = Hc + (p1+p2) * entropyMap(m_bar);
        end
        Itot = Itot - param.int_res * Hc;    
    end
end
Itot = max(Itot, 0);
newMap = map;
varargout{1} = UBI;