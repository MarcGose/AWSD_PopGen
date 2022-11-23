#!/bin/sh
# Grid Engine options
#$ -N convert_sam
#$ -cwd
#$ -l h_rt=12:00:00
#$ -l h_vmem=12G
#$ -t 1-93
#$ -pe sharedmem 2
#$ -R y
#$ -o o_files
#$ -e e_files

# Jobscript to index reference

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load java and set up variables

module add java

OUTPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/sorted.bam
TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa/mapped.bam

# Get list of files in target directory

BAM=$(ls -1 ${TARGET_DIR}/*mapped.bam)

# Get file to be processed by *this* task
# Extract the Nth file in the list of files, $bam, where N == $SGE_TASK_ID

THIS_BAM=$(echo "${BAM}" | sed -n ${SGE_TASK_ID}p)
echo Processing file: ${THIS_BAM} on $HOSTNAME

# Extract relevant bits for output file name

BASE=$(echo "$THIS_BAM" | cut -f 14 -d '/' | cut -f 1 -d '.')

echo Saving file ${THIS_BAM} as $OUTPUT_DIR/${BASE%.bam}_sorted.bam

java -Xmx16g -jar /exports/cmvm/eddie/eb/groups/ogden_grp/software/picard/picard.jar SortSam \
               I=$THIS_BAM \
               O=$OUTPUT_DIR/${BASE%.bam}_sorted.bam \
               SORT_ORDER=coordinate \
                       TMP_DIR=$OUTPUT_DIR \

