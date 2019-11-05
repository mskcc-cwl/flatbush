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
      - ^.dict
  - id: bam
    type: File 
    secondaryFiles:
      - ^.bai
  - id: known_sites
    type:
      type: array
      items: File
    secondaryFiles:
      - .idx
outputs:
  - id: output_baserecal
    outputSource:
      - gatk_base_recalibrator/output
    type: File
  - id: output_bam
    outputSource:
      - gatk_apply_bqsr/output
    type: File
    secondaryFiles:
      - ^.bai

steps:
  - id: gatk_base_recalibrator
    in:
      - id: reference
        source: reference_sequence
      - id: input
        source: bam
      - id: known_sites
        source: known_sites
    out:
      - id: output
    run: >-
      command_line_tools/gatk_4.1.0.0/gatk_base_recalibrator.cwl
    label: GATK Base Recalibrator
  - id: gatk_apply_bqsr
    in:
      - id: reference
        source: reference_sequence
      - id: input
        source:  bam
      - id: bqsr_recal_file 
        source: gatk_base_recalibrator/output
    out:
      - id: output
    run: >-
      command_line_tools/gatk_4.1.0.0/gatk_apply_bqsr.cwl
    label: GATK Apply BQSR
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
