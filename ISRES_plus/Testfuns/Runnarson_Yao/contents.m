% Improved Evolution Strategy (ES) using Stochastic Ranking (SR).
% 1-Apr-2004
%
% This MATLAB package comprises:
%
% 1.) Two script files
%
%  - run.m        run this script file to do experiments
%  - mktable.m    when "run.m" has finished use "mktable" to make a LaTeX table of results
%
% 2.) Two mex files
%
%  The mex files must be compiled from within MATLAB using the commands:
%  >> mex srsort.c
%  >> mex g12.c
%
% 3.) MATLAB function
%
%  - isres.m       this is the actual improved ES with stochastic ranking
%
% 4.) Test function suite
%
%  - gXX.m        where XX denotes the test function number
%
% Use HELP on these files or TYPE them for more information.
%
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
