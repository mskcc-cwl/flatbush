export LD_LIBRARY_PATH=/usr/local/bin/htslib-1.9/

filterType=$1
samples=$2
outfile=$3
inputFile=$4


delly filter \
  --filter $filterType \
  --samples $samples \
  --outfile $outfile \
  $inputFile
