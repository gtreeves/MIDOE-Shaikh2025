% MKTABLE 
% script that makes a latex table from experimental runs saved
% (you may want to change some parameters in this file
%  so it loads the correct "mat" result files)
% note: this file does a "close all, clear all"

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

clear all, close all

cfcn = ['g01';'g02';'g03';'g04';'g05';'g06';'g07';'g08';'g09';'g10';'g11';'g12';'g13'] ;
mxmn = ['min';'max';'max';'min';'min';'min';'min';'max';'min';'min';'min';'max';'min'] ;
Optimal = [-15 0.803619 1.000 -30665.539 5126.498 -6961.814 24.306 0.095825 680.630 7049.331 0.750 1.000 0.0539498] ;
Pf = 0.45 ;
fid = fopen('table.tex','w') ;
fprintf(fid,'\\documentclass[]{article}\n') ;
fprintf(fid,'\\begin{document}\n') ;
fprintf(fid,'\\begin{tabular}{|l|r|rrrrr|r|}\n') ;
fprintf(fid,'\\hline\\hline\n') ;
fprintf(fid,'{\\tt fcn}$_{(\\mbox{\\tiny feasible})}$ & optimal & best & median & mean & st. dev. & worst & $G_m$ \\\\\n') ;
fprintf(fid,'\\hline\n') ;
for i = [1 2 3 4 5 6 7 8 9 10 11 12 13],
  eval(['load ' cfcn(i,:) 'gau' num2str(round(Pf*100)) 'sr']) ;
  [f,g] = feval(cfcn(i,:),x) ;
  I = find(g<0) ; g(I) = 0 ;
  I = find(sum(g,2)>0)' ;
  J = find(sum(g,2)<=0) ;
  % for maximization problems change sign
  if (i==2)|(i==3)|(i==8)|(i==12),
    [length(J) -Optimal(i) -max(f(J)) -median(f(J)) -mean(f(J)) std(f(J)) -min(f(J))] ; 
  else
    [length(J) Optimal(i) min(f(J)) median(f(J)) mean(f(J)) std(f(J)) max(f(J))] ; 
  end
  % different precisions printed
  if (i==2)|(i==8)|(i==12)|(i==13),
    if isempty(J),
      fprintf(fid,'{\\tt %s}$_{(%d)}$ & $%.6f$ & -- & -- & -- & -- & -- & -- \\\\\n',[cfcn(i,:) ans(1:2)]) ;
    else 
      fprintf(fid,'{\\tt %s}$_{(%d)}$ & $%.6f$ & $%.6f$ & $%.6f$ & $%.6f$ & $%1.1E$ & $%.6f$ & $%d$ \\\\\n',cfcn(i,:),[ans fix(median(EV(J)))]) ;
    end
  else
    if isempty(J),
      fprintf(fid,'{\\tt %s}$_{(%d)}$ & $%.3f$ & -- & -- & -- & -- & -- & -- \\\\\n',[cfcn(i,:) ans(1:2)]) ;
    else 
      fprintf(fid,'{\\tt %s}$_{(%d)}$ & $%.3f$ & $%.3f$ & $%.3f$ & $%.3f$ & $%1.1E$ & $%.3f$ & $%d$ \\\\\n',cfcn(i,:),[ans fix(median(EV(J)))]) ;
    end   
  end
end
fprintf(fid,'\\hline\\hline\n') ;
fprintf(fid,'\\end{tabular}\n') ;
fprintf(fid,'\\end{document}}\n') ;
fclose(fid) ;
% !latex table
disp('see table.tex') ;
