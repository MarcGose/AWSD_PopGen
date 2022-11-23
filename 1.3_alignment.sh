#!/bin/sh
# Grid Engine options
#$ -N bwa_mem
#$ -cwd
#$ -l h_rt=12:00:00
#$ -l h_vmem=6G
#$ -t 1-93
#$ -pe sharedmem 2
#$ -R y
#$ -o o_files
#$ -e e_files
#$ -o xtrace
#$ -m beas

# Jobscript to align reads to reference genome


# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load bwa and samtools and set up variables

module load igmm/apps/bwa/0.7.16
module load igmm/apps/samtools/1.6

OUTPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/bwa
TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/barcode_removal/results
SAMPLE_SHEET="/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/file_lists/sample_path.txt"
REFERENCE=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/ref.genome/Lagenorhynchus_acutus_HiC.fasta

# get list of files

base=`sed -n "$SGE_TASK_ID"p "$SAMPLE_SHEET" | awk '{print $1}'`
r1=`sed -n "$SGE_TASK_ID"p "$SAMPLE_SHEET" | awk '{print $2}'`

# Process

echo Processing sample: "${base}" on "$HOSTNAME"

bwa mem -t 2 "$REFERENCE" "$TARGET_DIR"/"$r1" > "$OUTPUT_DIR"/"${base}"_mapped.sam
