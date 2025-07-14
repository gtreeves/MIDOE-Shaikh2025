function [f,g] = G06(x),
% G06 (Flounds and Pardalos, 1987)
% usage:  [f,g] = g06(x) ;
%
% isres('g06','min',[13 0;100 100],200,1750,30,0.45,1)
% xopt = [14.095 0.84296]

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
f = (x(:,1)-10).^3+(x(:,2)-20).^3 ;

% constraints g<=0
g(:,1) = -(x(:,1)-5).^2 - (x(:,2)-5).^2 + 100 ;
g(:,2) = (x(:,1)-6).^2 + (x(:,2)-5).^2 - 82.81 ;




