#!/bin/sh
# Grid Engine options
#$ -N MarkDups
#$ -cwd
#$ -l h_rt=24:00:00
#$ -l h_vmem=12G
#$ -pe sharedmem 4
#$ -t 1-93
#$ -R y
#$ -o o_files
#$ -e e_files

# Jobscript to mark and remove duplicates

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load java and set up variables

module add java

SCRATCH=/exports/eddie/scratch/s2113685
OUTPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/MarkDupl
TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/RG.bam

# Get list of files in target directory

BAM=$(ls -1 ${TARGET_DIR}/*_RG.bam)

# Get file to be processed by *this* task
# Extract the Nth file in the list of files, $bam, where N == $SGE_TASK_ID

THIS_BAM=$(echo "${BAM}" | sed -n ${SGE_TASK_ID}p)

# Extract relevant bits for output file names

BASE=$(echo "${BAM}" | sed -n ${SGE_TASK_ID}p | cut -f 14 -d '/' | cut -f 1 -d '.')

# Process

echo Processing file: ${THIS_BAM} on $HOSTNAME and saving ${BASE}

java -Xmx8g -jar /exports/cmvm/eddie/eb/groups/ogden_grp/software/picard/picard.jar MarkDuplicates \
       I=$THIS_BAM \
       O=${THIS_BAM%.bam}_rmdup.bam \
       METRICS_FILE=${THIS_BAM%.bam}_rmdup.metrics \
       ASSUME_SORTED=true \
       REMOVE_DUPLICATES=true \
       VALIDATION_STRINGENCY=SILENT \
       TMP_DIR=$SCRATCH \
       MAX_SEQUENCES_FOR_DISK_READ_ENDS_MAP=50000 \
       MAX_RECORDS_IN_RAM=50000

