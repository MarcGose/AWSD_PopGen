#!/bin/sh
# Grid Engine options
#$ -N ngsadmix
#$ -cwd
#$ -l h_rt=24:00:00
#$ -l h_vmem=4G
#$ -pe sharedmem 4
#$ -o o_files
#$ -e e_files
#$ -t 1-6

# Jobscript to NGSadmix on genotype likelihoods

# Initialise the Modules environment
. /etc/profile.d/modules.sh

# Set up variables

SOFTWARE_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/software/angsd/misc/
TARGET_DIR=/exports/cmvm/eddie/eb/groups/ogden_grp/marc/wsd_dart_2021/data/out/angsd/final_runs/all_together/wo_WSD80_79/run3_worel_wodup_red

# Process

for i in 1 2 3 4 5 6 7 8 9 10
do
        $SOFTWARE_DIR/NGSadmix \
        -likes $TARGET_DIR/WSD_GLs.beagle.gz \
        -K ${SGE_TASK_ID} \
        -P 4 \
        -seed $i \
        -o $TARGET_DIR/WSD_GLs_NGSadmix_K${SGE_TASK_ID}_run${i}_out
done

# Move .log and .qopt files to local mashine and plot Ln, Delta K and K=1-6 in R using Rscript XXX