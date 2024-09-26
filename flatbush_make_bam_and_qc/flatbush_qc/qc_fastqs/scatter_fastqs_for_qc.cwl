class: Workflow
cwlVersion: v1.0
id: scatter_fastqs_for_qc
label: scatter_fastqs_for_qc

inputs:
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

  r1:
    type: File[]
  r2:
    type: File[]
  output_prefix:
    type: string[]

outputs:
  fastp_html:
    type: File[]
    outputSource: fastp/html_output

  fastp_json:
    type: File[]
    outputSource: fastp/json_output

steps:
  fastp:
    in:
      tumor_sample: tumor_sample
      normal_sample: normal_sample
      in1: r1
      in2: r2
      output_prefix:
        valueFrom: ${ var data = []; data = inputs.tumor_sample.RG_ID.concat(inputs.normal_sample.RG_ID); return data }
      json:
        valueFrom: ${ return inputs.output_prefix + ".json"; }
      html:
        valueFrom: ${ return inputs.output_prefix + ".html"; }
    out: [ html_output, json_output ]
    run: fastp_0.19.7/fastp.cwl
    scatter: [ in1, in2, output_prefix ]
    scatterMethod: dotproduct

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
