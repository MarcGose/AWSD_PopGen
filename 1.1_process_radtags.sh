#!/bin/sh
# Grid Engine options
#$ -N process_radtags_dol
#$ -cwd
#$ -l h_rt=2:00:00
#$ -l h_vmem=4G
#$ -R y
#$ -t 1-101
#$ -e e_files
#$ -o o_files

# Jobscript to remove barcodes from dolphin libraries

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Load stacks and set up variables

module load roslin/stacks/2.5.4

INPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/raw
BARCODES=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/file_lists/barcode_list.txt
OUTPUT_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/barcode_removal

# Run process_radtags

SAMPLE=`ls $INPUT_DIR/*.FASTQ.gz`


THIS_SAMPLE=$(echo "${SAMPLE}" | sed -n ${SGE_TASK_ID}p)

# Extract relevant bits for output file names

base=`echo $THIS_SAMPLE | cut -f 12 -d '/' | cut -f 1 -d '.'`

process_radtags \
	-f $THIS_SAMPLE \
	-o ${OUTPUT_DIR}/${base} \
	-b $BARCODES \
	--inline-null \
	--renz_1 pstI \
	--renz_2 sphI \
	-c \
	-q \
	-r \
	--filter_illumina \
	-s 20 \
	-D \

# -c remove reads with uncalled bases
# -q discard reads with low quality scores
# -r rescue barcodes and radtags
