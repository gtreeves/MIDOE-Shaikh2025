function [f,g]=G09(x),
% G09 (Hock and Schittkowski, 1981, problem 100)
% usage: [f,g] = g09(x) ;
%
% isres('g09','min',[-10*ones(1,7);10*ones(1,7)],200,1750,30,0.45,1)
% xopt = [2.330499 1.951372 -0.4775414 4.365726 -0.6244870 1.038131 1.594227]

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
f = (x(:,1)-10).^2+5*(x(:,2)-12).^2+x(:,3).^4+3*(x(:,4)-11).^2+...
    10*x(:,5).^6+7*x(:,6).^2+x(:,7).^4-4*x(:,6).*x(:,7)-10*x(:,6)-8*x(:,7) ;

% contraints g<=0
g(:,1) = -127+2*x(:,1).^2+3*x(:,2).^4+x(:,3)+4*x(:,4).^2+5*x(:,5) ;
g(:,2) = -282+7*x(:,1)+3*x(:,2)+10*x(:,3).^2+x(:,4)-x(:,5) ;
g(:,3) = -196+23*x(:,1)+x(:,2).^2+6*x(:,6).^2-8*x(:,7) ;
g(:,4) = 4*x(:,1).^2+x(:,2).^2-3*x(:,1).*x(:,2)+2*x(:,3).^2+5*x(:,6)-11*x(:,7) ;













