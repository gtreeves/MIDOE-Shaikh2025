function [f,g] = G04(x),
% G04 (Himmelblau, 1972, problem 11, page 406)
% usage:  [f,g] = g04(x) ;
%
% isres('g04','min',[78 33 27*ones(1,3);102 45*ones(1,4)],200,1750,30,0.45,1)
% xopt = [78 33 29.995256025682 45 36.775812905788] % must be defined for at least E-12

% Copyleft (C) 2003-2004 Thomas Philip Runarsson (e-mail: tpr@hi.is)
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
% GNU General Public License for more details.

% fitness function
f = 5.3578547*x(:,3).^2+0.8356891*x(:,1).*x(:,5)+37.293239*x(:,1)-40792.141 ;

% constraints g<=0
g(:,1) = 85.334407 + 0.0056858*x(:,2).*x(:,5) + 0.0006262*x(:,1).*x(:,4) - 0.0022053*x(:,3).*x(:,5) - 92 ;
g(:,2) = -85.334407 - 0.0056858*x(:,2).*x(:,5) - 0.0006262*x(:,1).*x(:,4) + 0.0022053*x(:,3).*x(:,5) ;
g(:,3) = 80.51249 + 0.0071317*x(:,2).*x(:,5) + 0.0029955*x(:,1).*x(:,2) + 0.0021813*x(:,3).^2 - 110 ;
g(:,4) = -80.51249 - 0.0071317*x(:,2).*x(:,5) - 0.0029955*x(:,1).*x(:,2) - 0.0021813*x(:,3).^2 + 90 ;
g(:,5) = 9.300961 + 0.0047026*x(:,3).*x(:,5) + 0.0012547*x(:,1).*x(:,3) + 0.0019085*x(:,3).*x(:,4) - 25 ;
g(:,6) = -9.300961 - 0.0047026*x(:,3).*x(:,5) - 0.0012547*x(:,1).*x(:,3) - 0.0019085*x(:,3).*x(:,4) + 20 ;

