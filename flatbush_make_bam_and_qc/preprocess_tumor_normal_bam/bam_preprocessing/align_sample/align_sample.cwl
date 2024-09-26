class: Workflow
cwlVersion: v1.0
id: align_sample
label: align_sample
inputs:
  - id: reference_sequence
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
  - id: r1
    type: 'File[]'
  - id: r2
    type: 'File[]'
  - id: sample_id
    type: string
  - id: lane_id
    type: 'string[]'
outputs:
  - id: sample_id_output
    outputSource:
      - bwa_sort/sample_id_output
    type:
      - string
      - type: array
        items: string
  - id: output_md_metrics
    outputSource:
      - gatk_markduplicatesgatk/output_md_metrics
    type: File
  - id: output_merge_sort_bam
    outputSource:
      - samtools_merge/output_file
    type: File
  - id: output_md_bam
    outputSource:
      - gatk_markduplicatesgatk/output_md_bam
    type: File
    secondaryFiles: 
      - ^.bai
  - id: unmerged_bam
    type:
      type: array
      items: File
    outputSource:
      - bwa_sort/output_file

steps:
  - id: group_reads
    in: 
      - id: r1
        source: r1
      - id: r2
        source: r2
    out:
      - id: output
    run: joinr1r2.cwl

  - id: samtools_merge
    in:
      - id: input_bams
        source:
          - bwa_sort/output_file
    out:
      - id: output_file
    run: command_line_tools/samtools_1.9/samtools_merge.cwl
  - id: bwa_sort
    in:
      - id: r1
        source: r1
      - id: r2
        source: r2 
      - id: reference_sequence
        source: reference_sequence
      - id: read_pair
        source:
         - group_reads/output
      - id: sample_id
        source: sample_id
      - id: lane_id
        source: lane_id
    out:
      - id: output_file
      - id: sample_id_output
      - id: lane_id_output
    run: align_sort_bam/align_sort_bam.cwl
    label: bwa_sort
    scatter:
      - read_pair
      - lane_id
    scatterMethod: dotproduct
  - id: gatk_markduplicatesgatk
    in:
      - id: input
        source: samtools_merge/output_file
    out:
      - id: output_md_bam
      - id: output_md_metrics
    run: >-
      command_line_tools/gatk_4.1.0.0/gatk_mark_duplicates.cwl
    label: GATK MarkDuplicates
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
