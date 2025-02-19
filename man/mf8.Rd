% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/mf8.R
\name{mf8}
\alias{mf8}
\title{The reduced Fisher Information Matrix (FIM) for one individual parameterized with A,B,C matrices & using the derivative of variance.}
\usage{
mf8(model_switch, xt_ind, x, a, bpop, d, sigma, docc, poped.db)
}
\arguments{
\item{model_switch}{A vector that is the same size as xt, specifying which model each sample belongs to.}

\item{xt_ind}{A vector of sample times.}

\item{x}{A vector for the discrete design variables.}

\item{a}{A vector of covariates.}

\item{bpop}{The fixed effects parameter values.  Supplied as a vector.}

\item{d}{A between subject variability matrix (OMEGA in NONMEM).}

\item{sigma}{A residual unexplained variability matrix (SIGMA in NONMEM).}

\item{docc}{A between occasion variability matrix.}

\item{poped.db}{A PopED database.}
}
\value{
As a list:
\item{ret}{The FIM for one individual}
\item{poped.db}{A PopED database}
}
\description{
Compute the reduced FIM for one individual given specific model(s), parameters, design and methods.
This computation assumes that there is no correlation in the FIM between the fixed and random effects,
and set these elements in the FIM to zero.
This computation parameterizes the FIM calculation using
A,B,C matrices (as in Retout \emph{et al.}) but uses the derivative of variances.
Should give the same answer as \code{\link{mf3}} but computation times may be different.
}
\examples{
## Warfarin example from software comparison in:
## Nyberg et al., "Methods and software tools for design evaluation 
##   for population pharmacokinetics-pharmacodynamics studies", 
##   Br. J. Clin. Pharm., 2014. 

library(PopED)

## find the parameters that are needed to define from the structural model
ff.PK.1.comp.oral.sd.CL

## -- parameter definition function 
## -- names match parameters in function ff
sfg <- function(x,a,bpop,b,bocc){
  parameters=c(CL=bpop[1]*exp(b[1]),
               V=bpop[2]*exp(b[2]),
               KA=bpop[3]*exp(b[3]),
               Favail=bpop[4],
               DOSE=a[1])
  return(parameters) 
}

## -- Define initial design  and design space
poped.db <- create.poped.database(ff_file="ff.PK.1.comp.oral.sd.CL",
                                  fg_file="sfg",
                                  fError_file="feps.prop",
                                  bpop=c(CL=0.15, V=8, KA=1.0, Favail=1), 
                                  notfixed_bpop=c(1,1,1,0),
                                  d=c(CL=0.07, V=0.02, KA=0.6), 
                                  sigma=0.01,
                                  groupsize=32,
                                  xt=c( 0.5,1,2,6,24,36,72,120),
                                  minxt=0,
                                  maxxt=120,
                                  a=70)
# warfarin optimization model

#for the FO approximation
ind=1

# no occasion defined in this example, so result is zero
output <- mf8(model_switch=t(poped.db$design$model_switch[ind,,drop=FALSE]),
   xt=t(poped.db$design$xt[ind,,drop=FALSE]),
   x=zeros(0,1),
   a=t(poped.db$design$a[ind,,drop=FALSE]),
   bpop=poped.db$parameters$bpop[,2,drop=FALSE],
   d=poped.db$parameters$param.pt.val$d,
   sigma=poped.db$parameters$sigma,
   docc=poped.db$parameters$param.pt.val$docc,
   poped.db)

# in this simple case the full FIM is just the sum of the individual FIMs
# and all the individual FIMs are the same
det(output$ret*32) == det(evaluate.fim(poped.db,fim.calc.type=7))  
}
\references{
S. Retout and F. Mentre, "Further developments of the Fisher Information Matrix in
nonlinear mixed effects models with evaluation in population pharmacokinetics", J. of Biopharm. Stats., 13(2), 2003.
}
\seealso{
Used by \code{\link{mftot7}}.

Other FIM: \code{\link{LinMatrixH}};
  \code{\link{LinMatrixLH}}; \code{\link{LinMatrixL_occ}};
  \code{\link{calc_ofv_and_fim}};
  \code{\link{ed_laplace_ofv}}; \code{\link{ed_mftot}};
  \code{\link{evaluate.e.ofv.fim}};
  \code{\link{evaluate.fim}}; \code{\link{gradf_eps}};
  \code{\link{mf3}}; \code{\link{mf5}}; \code{\link{mf6}};
  \code{\link{mf7}}; \code{\link{mftot0}};
  \code{\link{mftot1}}; \code{\link{mftot2}};
  \code{\link{mftot3}}; \code{\link{mftot4}};
  \code{\link{mftot5}}; \code{\link{mftot6}};
  \code{\link{mftot7}}; \code{\link{mftot}};
  \code{\link{mf}}; \code{\link{ofv_criterion}};
  \code{\link{ofv_fim}}
}

