#!/bin/sh
# Grid Engine options
#$ -N pcangsd
#$ -cwd
#$ -l h_rt=2:00:00
#$ -l h_vmem=6G
#$ -pe sharedmem 2
#$ -o o_files
#$ -e e_files

# Jobscript to run PCAngsd on genotype likelihoods

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load python and anaconda
module load python
module load anaconda

# Activate pcangsd conda env.

source activate pcangsd

# Set up variables

SOFTWARE_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/software/pcangsd
TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/angsd/PCAngsd

# Process

python "${SOFTWARE_DIR}"/pcangsd.py \
        -beagle "${TARGET_DIR}"/WSD_GLs.beagle.gz \
        -threads 4 \
        -o "${TARGET_DIR}"/WSD_GLs_PCAngsd_covmat

# Move covmat to local mashine and plot PCA using Rscript XXX
