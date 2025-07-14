function [f,g] = G12(x),
% Michalewicz and Koziel (1999)
% usage:  [f,g] = g12(x) ;
%
% isres('g12','max',[zeros(1,3);10*ones(1,3)],200,1750,30,0.45,1)
% xopt = [5 5 5]
%
% see also g12.c (the mex file was used in our experiments)
% (this m-file is extremely slow!)

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

% objective function
f = (100-(x(:,1)-5).^2-(x(:,2)-5).^2-(x(:,3)-5).^2)/100 ;

% constraints
% p = [1 3 5 7 9] ;
p = 1:9 ;
q = p ;
r = q ;
l = 1 ;
for i=1:length(p),
  for j=1:length(q), 
    for k=1:length(r),
      g(:,l) = (x(:,1)-p(i)).^2+(x(:,2)-q(j)).^2+(x(:,3)-r(k)).^2 - 0.0625 ;
      l = l+1 ;
    end
  end
end
g = min(g,[],2) ;
