function [f,g] = G03(x),
% G03 (Michalewicz et. al., 1996)
% usage:  [f,g]=g03(x) ;
%
% isres('g03','max',[zeros(1,10);ones(1,10)],200,1750,30,0.45,1)
% xopt = ones(1,10)/sqrt(10)

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

n = size(x,2) ;
delta = 0.0001 ; % tolerated equality constraint violation

% fitness function
f = (sqrt(n)^n)*prod(x,2) ;

% constraints h=0 => g=|h|-delta<=0
g(:,1) = abs(sum(x.^2,2) - 1) - delta ;













