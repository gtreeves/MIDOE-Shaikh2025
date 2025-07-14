function [f,g] = G10(x),
% G10 (Hock and Schittkowski, 1981, problem 106, heat exchanger design)
% usage:  [f,g] = g10(x) ;
%
% isres('g10','min',[100 1000 1000 10*ones(1,5);10000*ones(1,3) 1000*ones(1,5)],200,1750,30,0.45,1/4)
% optimal:
% xopt = [579.3167 1359.943 5110.071 182.0174 295.5985 217.9799 286.4162 395.5979]
% solution found which is better but requires more precision:
% xopt = [582.45260912629703 1366.18246979548850 5100.64213412946630 182.27986043132657 295.97431463482127 217.72013956867343 286.30554579650538 395.97431463482127]
% all constrains are active with the exception of the fourth g4=-0.14551915228367E-10

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
f = sum(x(:,1:3),2) ;

% constraints g<=0
g(:,1) = -1+0.0025*(x(:,4)+x(:,6)) ;
g(:,2) = -1+0.0025*(x(:,5)+x(:,7)-x(:,4)) ;
g(:,3) = -1+0.01*(x(:,8)-x(:,5)) ;
g(:,4) = -x(:,1).*x(:,6)+833.33252*x(:,4)+100*x(:,1)-83333.333 ;
g(:,5) = -x(:,2).*x(:,7)+1250*x(:,5)+x(:,2).*x(:,4)-1250*x(:,4) ;
g(:,6) = -x(:,3).*x(:,8)+1250000+x(:,3).*x(:,5)-2500*x(:,5) ;
