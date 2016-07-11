function p = mixtureModelDensity(z, d, param)

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

Pshort = double(z>d) * 1/(1-exp(-param.lambda_short * d)) * param.lambda_short * exp(-param.lambda_short * z);

if abs(z - d) < .05
    Pmax = 1;
else
    Pmax = 0;
end
if z > param.Z_max
    P_rand = 0;
else
    P_rand = param.p_rand;
end

if z < param.Z_max && z > 0
    Phit = exp(-0.5 * ((z - d)./param.sigma_hit).^2) ./ (sqrt(2*pi) .* param.sigma_hit);
else
    Phit = 0;
end

p = max(param.z_short * Pshort + param.z_hit * Phit + param.z_rand * P_rand + param.z_max * Pmax, param.p_rand);

