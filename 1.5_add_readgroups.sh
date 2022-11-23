#!/bin/sh
# Grid Engine options
#$ -N add_RG
#$ -cwd
#$ -l h_rt=6:00:00
#$ -l h_vmem=12G
#$ -pe sharedmem 2
#$ -t 1-93
#$ -R y
#$ -o o_files
#$ -e e_files

# Jobscript to add/delete read groups

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load java and set up variables

module add java

OUTPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/RG.bam
TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/sorted.bam/missID_WBD

# Get list of files in target directory

BAM=$(ls -1 ${TARGET_DIR}/*.sorted.bam)

# Get file to be processed by *this* task
# Extract the Nth file in the list of files, $bam, where N == $SGE_TASK_ID

THIS_BAM=$(echo "${BAM}" | sed -n ${SGE_TASK_ID}p)

# Extract relevant bits for output file name

BASE=$(echo "${BAM}" | sed -n ${SGE_TASK_ID}p | cut -f 14 -d '/' | cut -f 1 -d '.')

# Process

echo Processing file: ${THIS_BAM} on $HOSTNAME and saving ${BASE}

java -Xmx4g -jar /exports/cmvm/eddie/eb/groups/ogden_grp/software/picard/picard.jar AddOrReplaceReadGroups \
       I=$THIS_BAM \
       O=${THIS_BAM%.bam}_RG.bam \
       RGID=$BASE \
       RGPL=illumina \
       RGLB=$BASE \
       RGPU=$BASE \
       RGSM=$BASE \
       VALIDATION_STRINGENCY=SILENT \
       SORT_ORDER=coordinate \
       TMP_DIR=$OUTPUT_DIR

