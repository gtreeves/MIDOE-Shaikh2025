function [f,g] = G02(x),
% G02 (Keane, 1994)
% usage: [f,g] = g02(x) ;
%
% isres('g02','max',[zeros(1,20);10*ones(1,20)],200,1750,30,0.45,1)
% optimal solution? (we found this one):
% xopt = [ ...
% 3.16237443645701 3.12819975856112 3.09481384891456 3.06140284777302 ...
% 3.02793443337239 2.99385691314995 2.95870651588255 2.92182183591092 ...
% 0.49455118612682 0.48849305858571 0.48250798063845 0.47695629293225 ...
% 0.47108462715587 0.46594074852233 0.46157984137635 0.45721400967989 ...
% 0.45237696886802 0.44805875597713 0.44435772435707 0.44019839654132]

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
f = abs(sum((cos(x).^4),2) - 2*prod((cos(x).^2),2))./...
    sqrt(sum(((ones(size(x,1),1)*[1:size(x,2)]).*(x.^2)),2)) ;

% constraints g<=0
g(:,1) = 0.75-prod(x,2) ;
g(:,2) = sum(x')'-7.5*size(x,2) ;

