function [f,g] = G08(x),
% G08 (Schoenauer and Xanthakis, 1993)
% usage:  [f,g] = g08(x) ;
%
% isres('g08','max',[0 0;10 10],200,1750,30,0.45,1) ;
% xopt = [1.2279713, 4.2453733]

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

% fitness functions
f = ((sin(2*pi*x(:,1)).^3).*sin(2*pi*x(:,2)))./((x(:,1).^3).*(x(:,1)+x(:,2))) ;

% constraints g<=0
g(:,1) = x(:,1).^2 - x(:,2) + 1 ;
g(:,2) = 1 - x(:,1) + (x(:,2)-4).^2 ;

