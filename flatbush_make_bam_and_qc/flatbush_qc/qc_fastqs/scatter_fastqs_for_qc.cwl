class: Workflow
cwlVersion: v1.0
id: scatter_fastqs_for_qc
label: scatter_fastqs_for_qc

inputs:
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
      in1: r1
      in2: r2
      output_prefix: output_prefix
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
