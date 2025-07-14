/*
 * G12 Test function from Michalewicz and Koziel (1999)
 * Copyleft (C) 2003-2004 Thomas Philip Runarsson (e-mail: tpr@hi.is)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 */

#include "mex.h"
#define MIN(A,B) ((A) < (B) ? (A):(B))

#ifdef __STDC__
void mexFunction(int nlhs,mxArray *plhs[],int nrhs, const mxArray *prhs[])
#else
void mexFunction(nlhs, plhs, nrhs, prhs)
int nlhs, nrhs ;
mxArray *plhs[] ;
const mxArray *prhs[] ;
#endif
{
  int n, m ;
  double *f, *g, *x, gt ;  
  int i, j, k, l ;

  /* check input arguments */
  if ((nrhs != 1) || (nlhs != 2))
    mexErrMsgTxt("usage: [f,g] = g12(x) ;") ;

  /* get pointers to input */
  m = mxGetM(prhs[0]) ;
  n = mxGetN(prhs[0]) ;
  x = mxGetPr(prhs[0]) ;

  if (n!=3)
    mexErrMsgTxt("fault: this function requires 3 input variables") ;

  /* initialize index */
  plhs[0] = mxCreateDoubleMatrix(m,1,mxREAL) ;
  plhs[1] = mxCreateDoubleMatrix(m,1,mxREAL) ;
  f = mxGetPr(plhs[0]) ;
  g = mxGetPr(plhs[1]) ;

/* objective function */
  for (i=0;i<m;i++)
    f[i] = (100-(x[0*m+i]-5)*(x[0*m+i]-5)-(x[1*m+i]-5)*(x[1*m+i]-5)-(x[2*m+i]-5)*(x[2*m+i]-5))/100 ;

/* constraints */
  for (l=0;l<m;l++)  {
    g[l] = (x[0*m+l]-1)*(x[0*m+l]-1)+(x[1*m+l]-1)*(x[1*m+l]-1)+(x[2*m+l]-1)*(x[2*m+l]-1) - 0.0625 ;
    for (i=1;i<=9;i++) {
      for (j=1;j<=9;j++) {
        for (k=1;k<=9;k++) {
          gt = (x[0*m+l]-i)*(x[0*m+l]-i)+(x[1*m+l]-j)*(x[1*m+l]-j)+(x[2*m+l]-k)*(x[2*m+l]-k) - 0.0625 ;
          if (gt<g[l])
            g[l] = gt ;
        }
      }
    }
  }
}
