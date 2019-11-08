class: Workflow
cwlVersion: v1.0
id: gatk_mutect2_workflow

inputs:
  - id: genomeFile
    type: File
    doc: Input genome file
  - id: intervalBed
    type: File
    doc: Interval bed file
  - id: bamTumor
    type: File
    doc: Tumor BAM
  - id: idTumor
    type: string?
  - id: bamNormal
    type: File
    doc: Normal BAM
  - id: idNormal
    type: string?
  - id: scatterCount
    type: int?
  - id: split_intervals_output_dir
    type: string?
    default: 'split_interval_files'
outputs:
  - id: filteredMutect2Vcf
    doc: Output filtered mutect2 VCF
    type:
      type: array
      items: File
    outputSource: run_filter_mutect_calls/filteredMutect2Vcf
steps:
  run_split_intervals:
    in:
      genomeFile: genomeFile
      agilentTargets: intervalBed
      scatterCount: scatterCount
      output_dir: split_intervals_output_dir
    out: [ split_interval_files ]
    run: gatk_split_intervals.cwl
  run_mutect2:
    in:
      genomeFile: genomeFile
      intervalFile: run_split_intervals/split_interval_files
      bamTumor: bamTumor
      idTumor: idTumor
      bamNormal: bamNormal
      idNormal: idNormal
    out: [ mutect2Vcf ]
    scatter: [ intervalFile ]
    run: gatk_mutect2.cwl

  run_filter_mutect_calls:
    in:
      mutect2Vcf: run_mutect2/mutect2Vcf
    scatter: [ mutect2Vcf ]
    out: [ filteredMutect2Vcf ]
    run: gatk_filter_mutect_calls.cwl
requirements:
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 4
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk:4.1.0.0'
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: ScatterFeatureRequirement
