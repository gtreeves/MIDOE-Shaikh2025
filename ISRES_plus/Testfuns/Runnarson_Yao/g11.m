function [f,g] = G11(x),
% G11 (Maa and Shanblatt, 1992)
% usage:  [f,g] = g11(x) ;
%
% isres('g11','min',[-1 -1;1 1],200,1750,30,0.45,1)
% xopt = [0.70711 0.5] or [-0.70711 0.5]

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
f = x(:,1).^2+(x(:,2)-1).^2 ;

% constraint h=0 => g=|h|-delta<=0
g(:,1) = abs(x(:,2) - x(:,1).^2) - delta ;

