#!/bin/sh
# Grid Engine options
#$ -N angsd_gl
#$ -cwd
#$ -l h_rt=24:00:00
#$ -l h_vmem=8G
#$ -pe sharedmem 4
#$ -o o_files
#$ -e e_files
#$ -o xtrace

# Jobscript to:
# Filter SNPs by read depth and callrate
# Genotype calling
# calculate allele frequency

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load java and set up variables

module add java

SOFTWARE_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/emily/software/angsd-v0.935-53
BAM_LIST=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/file_lists/bamlist_angsd.txt
OUTPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/angsd/final/
REFERENCE=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/ref.genome/Lagenorhynchus_acutus_HiC.fasta

# Run process

# Genotype likelihoods and SNP / allele frequencies

$SOFTWARE_DIR/angsd \
        -b $BAM_LIST \
        -ref $REFERENCE \
        -P 4 \
        -out $OUTPUT_DIR/WSD_GLs \
        -uniqueOnly 1 \
        -remove_bads 1 \
        -only_proper_pairs 1 \
        -trim 0 \
        -C 50 \
        -baq 1 \
        -minMapQ 30 \
        -minQ 30 \
        -minInd 73 \
        -doCounts 1 \
        -GL 2 \
        -doGlf 2 \
        -doMajorMinor 4 \
        -doMaf 1 \
        -SNP_pval 1e-6 \
        -doGeno 2 \
        -doPost 1 \
        -setMinDepth 455 \
	   -setMaxDepth 4550 \
        -doPlink 2

