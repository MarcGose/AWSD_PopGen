#!/bin/sh
# Grid Engine options
#$ -N IndexRef
#$ -cwd
#$ -l h_rt=6:00:00
#$ -l h_vmem=16G
#S -pe sharedmem 4
#$ -o o_files
#$ -e e_files

# Jobscript to index reference

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load bwa and set up variables

module load roslin/bwa/0.7.17

REFERENCE=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/assembly/Lagenorhynchus_acutus_HiC.fasta

# index reference genome with bwa for mapping SNPs

bwa index $REFERENCE
