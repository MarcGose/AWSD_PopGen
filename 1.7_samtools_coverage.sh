#!/bin/sh
# Grid Engine options
#$ -N sam_coverage
#$ -cwd
#$ -l h_rt=4:00:00
#$ -l h_vmem=6G
#$ -t 1-93
#$ -pe sharedmem 4
#$ -R y
#$ -o o_files
#$ -e e_files
#$ -o xtrace

# Jobscript to get coverage

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load samtools and set up variables

module load igmm/apps/samtools/1.13

OUTPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa
TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/sorted.bam
SAMPLE_SHEET="/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/file_lists/bam_sorted.txt"
REFERENCE=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/ref.genome/Lagenorhynchus_acutus_HiC.fasta

# get list of files

base=`sed -n "$SGE_TASK_ID"p "$SAMPLE_SHEET" | awk '{print $1}'`

# Process

echo Processing sample: "${base}" on "$HOSTNAME"

samtools coverage -b "${SAMPLE_SHEET}" -o $OUTPUT_DIR/${base%.bam}coverage
