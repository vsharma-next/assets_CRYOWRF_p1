#!/bin/csh                                        
#SBATCH --job-name=CT_extract
##SBATCH --output=/scratch-shared/meteoswiss/scratch/vsharma/cosmo_to_wrf/fieldextra.stdeo_242276
##SBATCH --error=/scratch-shared/meteoswiss/scratch/vsharma/cosmo_to_wrf/fieldextra.stdeo_242276
#SBATCH --partition=postproc                                            
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --time=24:00:00                                            
#                                                     
# Initialization                                      
unalias * ; unset noclobber

  unlimit stacksize                # unlimit stack size
  setenv OMP_STACKSIZE 500M        # increase OpenMP stack size

setenv OMP_PLACES sockets
setenv OMP_PROC_BIND "spread,close,close"

/users/tsm/project_rh7.7/fieldextra/v13_3_1/bin/fieldextra_gnu_opt_omp cosmo_to_wrf.nl
exit 0
~                             
