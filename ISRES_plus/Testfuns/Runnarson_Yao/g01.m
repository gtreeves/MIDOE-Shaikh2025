function [f,g] = G01(x),
% G01 (Floundas and Pardalos, 1987)
% usage:  [f,g] = g01(x) ;
%
% isres('g01','min',[zeros(1,13);ones(1,9) 100*ones(1,3) 1],200,1750,30,0.45,1)
% xopt = [1 1 1 1 1 1 1 1 1 3 3 3 1]

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
f = 5*sum(x(:,1:4),2) - 5*sum((x(:,1:4).^2),2) - sum(x(:,5:13),2) ;

% constraints g<=0
g(:,1) = 2*x(:,1)+2*x(:,2)+x(:,10)+x(:,11) - 10 ;
g(:,2) = 2*x(:,1)+2*x(:,3)+x(:,10)+x(:,12) - 10 ;
g(:,3) = 2*x(:,2)+2*x(:,3)+x(:,11)+x(:,12) - 10 ;
g(:,4) = -8*x(:,1)+x(:,10) ;
g(:,5) = -8*x(:,2)+x(:,11) ;
g(:,6) = -8*x(:,3)+x(:,12) ;
g(:,7) = -2*x(:,4)-x(:,5)+x(:,10) ;
g(:,8) = -2*x(:,6)-x(:,7)+x(:,11) ;
g(:,9) = -2*x(:,8)-x(:,9)+x(:,12) ;













