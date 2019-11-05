export LD_LIBRARY_PATH=/usr/local/bin/htslib-1.9/

svType=$1
genomeFile=$2
svCallingExcludeRegions=$3
outfile=$4
bamTumor=$5
bamNormal=$6

delly call \
  --svtype ${svType} \
  --genome ${genomeFile} \
  --exclude ${svCallingExcludeRegions} \
  --outfile ${outfile} \
  ${bamTumor} ${bamNormal}
