# AWSD_PopGen
This repository contains all scripts for the processing of raw DArTseq reads of Atlantic white-sided dolphins and all downstream population genetics analyses.
Raw data files were aligned with BWA and genotype likelihoods calculated in ANGSD.
Analysis include estimation of population structure using PCAngsd, DAPC, KLFDAPC and NGSadmix, estimation of IBD and individual pairwise relatedness using PLINK and NGSrelate and estimation of inbreeding and genetic diversity (sMLH) in PLINK and InbreedR.

All analyses were performed on a HPC cluster within bash scripts.
All downstream summary statistics and visualisations took part in R and RStudio.
Some functions of the PLINK package, NGSrelate, NGSld and some data wrangling steps were performed on an interactive node and are documented in Workflow.txt

The reference assembly used for mapping and representation of a western North Atlantic individual in the dataset can be found here: https://www.dnazoo.org/assemblies/Lagenorhynchus_acutus

Manuscript "Stranding collections uncover broad-scale connectivity in a pelagic marine predator, the Atlantic white‑sided dolphin (Lagenorhynchus acutus)" is available here: https://tinyurl.com/4snpphjt

M.Sc. Marc-Alexander Gose
Ph.D. candidate in conservation genetics
Royal (Dick) School of Veterinary Studies and the Roslin Institute
University of Edinburgh
marc-alexander.gose@ed.ac.uk
