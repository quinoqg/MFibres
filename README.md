# MatlabFibres
Analysis of the mechanical performance of fibres

# Function FibreBwbModel
 This function runs a virtual experiment in whic a fibre bundle with
 nFibres parallel fibres are pulled in a strain controlled manner. The
 arguments are:
     *FibreE:    Elastic Modulus of the fibre
     *nFibre:    Number of fibres in the bundle
     *k and gam: Shape and scale Weibull factors respectively
     *FibreDiam: Fibre diameter
     *DistType:  either 'wbl' for Weibull distribution or 'norm' for normal
     distribution
 The output:
   *A Matrix where the columns contain the Strain, Force, Stress, and
   cumulative number of broken fibres for each stran step.
