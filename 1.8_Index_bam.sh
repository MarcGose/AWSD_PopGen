#!/bin/sh
# Grid Engine options
#$ -N IndexBam
#$ -cwd
#$ -l h_rt=12:00:00
#$ -l h_vmem=8G
#$ -pe sharedmem 4
#$ -t 1-93
#$ -o o_files
#$ -e e_files

# Jobscript to index bams

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load java and set up variables

module add roslin/samtools/1.9

# Specify some paths

TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/RG.bam

# Get list of files in target directory

BAM=$(ls -1 ${TARGET_DIR}/*_sorted_RG.bam)

# Get the file to be processed by *this* task
# Extract the Nth file in the list of files, $bam, where N == $SGE_TASK_ID

THIS_BAM=$(echo "${BAM}" | sed -n ${SGE_TASK_ID}p)
echo Processing file: ${THIS_BAM} on $HOSTNAME

# index bams

samtools index ${THIS_BAM}

