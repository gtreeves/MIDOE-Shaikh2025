function [f,g] = G13(x),
% G13 (Hock And Schittkowski, 1981)
% usage:  [f,g] = g13(x) ;
%
% isres('g13','min',[-2.3 -2.3 -3.2*ones(1,3);2.3 2.3 3.2*ones(1,3)],200,1750,30,0.45,1)
% xopt = [-1.717143 1.595709 1.827247 -0.7636413 -0.7636450]

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

delta = 0.0001 ;

% fitness function
f = exp(x(:,1).*x(:,2).*x(:,3).*x(:,4).*x(:,5)) ;

% equality constraints
g(:,1) = x(:,1).^2+x(:,2).^2+x(:,3).^2+x(:,4).^2+x(:,5).^2 - 10 ;
g(:,2) = x(:,2).*x(:,3)-5*x(:,4).*x(:,5) ;
g(:,3) = x(:,1).^3+x(:,2).^3 + 1 ;
g = abs(g) - delta ;
