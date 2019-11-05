cwlVersion: v1.0

class: CommandLineTool
baseCommand: [snp-pileup]
id: snp-pileup

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: cmopipeline/facets-htstools:2.2.2
  ResourceRequirement:
    ramMin: 8000
    coresMin: 1

doc: |
  Run snp-pileup on a vcf file

inputs:
  vcf_file:
    type: File
    inputBinding:
      position: 0

  output_file:
    type: string
    inputBinding:
      position: 1

  bam_normal:
    type: File
    inputBinding:
      position: 2

  bam_tumor:
    type: File
    inputBinding:
      position: 3

  count_orphans:
    default: true
    type: boolean
    inputBinding:
      prefix: -A

  pseudo_snps:
    type: int
    default: 50
    inputBinding:
      prefix: -P

  gzip:
    type: boolean
    default: true
    inputBinding:
      prefix: --gzip

  ignore_overlaps:
    type: boolean?
    default: false
    inputBinding:
      prefix: --ignore-overlaps

  max_depth:
    type: int?
    inputBinding:
      prefix: -d

  min_base_quality:
    type: int?
    inputBinding:
      prefix: --min-base-quality

  min_read_counts:
    type: int?
    inputBinding:
      prefix: --min-read-counts

  min_map_quality:
    type: int?
    inputBinding:
      prefix: --min-map-quality

outputs:
  output_file:
    type: File
    outputBinding:
      glob: '*.*'
