class: Workflow
cwlVersion: v1.0
id: preprocess_tumor_normal_pair
label: preprocess_tumor_normal_pair

inputs:
  reference_sequence:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict

  tumor_sample:
    type:
      type: record
      fields:
        ID: string
        CN: string
        LB: string
        PL: string
        PU: string[]
        R1: File[]
        R2: File[]
        RG_ID: string[]
        adapter: string
        adapter2: string
        bwa_output: string

  normal_sample:
    type: 
      type: record
      fields:
        ID: string
        CN: string
        LB: string
        PL: string
        PU: string[]
        R1: File[]
        R2: File[]
        RG_ID: string[]
        adapter: string
        adapter2: string
        bwa_output: string

  known_sites:
    type:
      type: array
      items: File
    secondaryFiles:
      - .idx

outputs:
  tumor_bam:
    type: File
    outputSource: make_bam_tumor/output_bam
    secondaryFiles:
      - ^.bai
  normal_bam:
    type: File
    outputSource: make_bam_normal/output_bam
    secondaryFiles:
      - ^.bai

steps:
  make_bam_tumor:
    in:
      sample: tumor_sample
      reference_sequence: reference_sequence
      known_sites: known_sites
      r1: 
        valueFrom: ${ return inputs.sample.R1 }
      r2:
        valueFrom: ${ return inputs.sample.R2}
      lane_id: 
        valueFrom: ${ return inputs.sample.RG_ID }
      sample_id:
        valueFrom: ${ return inputs.sample.ID }
    out: [ output_bam ]
    run: bam_preprocessing/bam_preprocessing.cwl

  make_bam_normal:
    in:
      sample: normal_sample
      reference_sequence: reference_sequence
      known_sites: known_sites
      r1: 
        valueFrom: ${ return inputs.sample.R1 }
      r2:
        valueFrom: ${ return inputs.sample.R2 }
      lane_id: 
        valueFrom: ${ return inputs.sample.RG_ID }
      sample_id:
        valueFrom: ${ return inputs.sample.ID }
    out: [ output_bam ]
    run: bam_preprocessing/bam_preprocessing.cwl

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
