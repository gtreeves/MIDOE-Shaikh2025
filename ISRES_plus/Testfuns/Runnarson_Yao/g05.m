function [f,g] = G05(x),
% G05 (Hock and Schittkowski, 1981, problem 74)
% usage:  [f,g] = g05(x) ;
%
% isres('g05','min',[0 0 -0.55 -0.55;1200 1200 0.55 0.55],200,1750,30,0.45,1)
% xopt = [679.9453 1026.067 0.1188764 -0.3962336]
 
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

delta = 0.0001 ; % tolerated equality constraint violation

% fitness function
f = 3*x(:,1) + 0.000001*x(:,1).^3 + 2*x(:,2) + (0.000002/3).*(x(:,2).^3) ;

% constraints g<=0
g(:,1) = -x(:,4) + x(:,3) - 0.55 ;
g(:,2) = -x(:,3) + x(:,4) - 0.55 ;

% constraints h=0 => g=|h|-delta<=0
g(:,3) = 1000*sin(-x(:,3)-0.25) + 1000*sin(-x(:,4)-0.25) + 894.8 - x(:,1) ;
g(:,4) = 1000*sin(x(:,3)-0.25) + 1000*sin(x(:,3)-x(:,4)-0.25) + 894.8 - x(:,2) ;
g(:,5) = 1000*sin(x(:,4)-0.25) + 1000*sin(x(:,4)-x(:,3)-0.25) + 1294.8 ;
g(:,3:5) = abs(g(:,3:5))-delta ;













