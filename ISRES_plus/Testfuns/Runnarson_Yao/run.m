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

clear all, % close all
format long, format compact
cfcn = ['g01';'g02';'g03';'g04';'g05';'g06';'g07';'g08';'g09';'g10';'g11';'g12';'g13'] ;
mxmn = ['min';'max';'max';'min';'min';'min';'min';'max';'min';'min';'min';'max';'min'] ;
lu1  = [zeros(1,13);ones(1,9) 100*ones(1,3) 1] ;
lu2  = [zeros(1,20);10*ones(1,20)] ;
lu3  = [zeros(1,10);ones(1,10)] ;
lu4  = [78 33 27*ones(1,3);102 45*ones(1,4)] ;
lu5  = [0 0 -0.55 -0.55;1200 1200 0.55 0.55] ;
lu6  = [13 0;100 100] ;
lu7  = [-10*ones(1,10);10*ones(1,10)] ;
lu8  = [0 0;10 10] ;
lu9  = [-10*ones(1,7);10*ones(1,7)] ;
lu10 = [100 1000 1000 10*ones(1,5);10000*ones(1,3) 1000*ones(1,5)]  ;
lu11 = [-1 -1;1 1] ;
lu12 = [zeros(1,3);10*ones(1,3)] ;
lu13 = [-2.3 -2.3 -3.2*ones(1,3);2.3 2.3 3.2*ones(1,3)] ;
G = [1750 1750 1750 1750 1750 1750 1750 1750 1750 1750 1750 175 1750] ; 
mut = 'gau'
mu = 30 ;
lambda = 200 ;
nrr = 30 ;

% in our experiments we tried different settings for the following two parameters
pf = 0.45 ; 
varphi = 1 ;

for i = [1 2 3 4 5 6 7 8 9 10 11 12 13],
  clear x EV C
  C = zeros(G(i),3) ;
  E = zeros(G(i),1) ;
  K = [] ;
  lu = eval(['lu' num2str(i)]) ;
  for j=1:nrr,
    [i j]
    [x(j,:),c,EV(j)] = isres(cfcn(i,:),mxmn(i,:),lu,lambda,G(i),mu,pf,varphi) ;
    [f,g] = feval(cfcn(i,:),x) ;
    C = C + c ;
    [min(f) median(f) mean(f) std(f) max(f)]
  end
  C = C/nrr ;
  if (varphi==1)
    eval(['save ' cfcn(i,:) mut num2str(round(pf*100)) 'sr x EV C varphi']) ;
  else
    eval(['save ' cfcn(i,:) mut num2str(round(pf*100)) 'srn x EV C varphi']) ;
  end
  [f,phi] = feval(cfcn(i,:),x) ;
  [min(f) median(f) mean(f) std(f) max(f)]
  median(EV),find(phi>0)
end
