# tempo_qc
QC  module for FLATBUSH pipeline

### qc_wrapper
Specific to FLATBUSH.

The `collect_hs_metrics.cwl` runs a container that holds `run_hsmetrics.py` and jars from the Broad Institute.

The script `run_hsmetrics.py` wraps the `gatk CollectHsMetrics` command so that if bait or target interval list files are not provided execution is skipped. An output file will be returned, indicating it was not executed.

### Other modules
The repos for `qc_bams` and `qc_fastqs` are submodularized here; FLATBUSH uses Alfred to get BAM QC values and FastP for FastQ QC.
