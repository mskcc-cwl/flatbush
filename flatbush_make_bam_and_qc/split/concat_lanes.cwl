class: ExpressionTool
cwlVersion: v1.0
id: concat_lanes
label: concat_lanes

inputs:
  sample:
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
    type:
      type: array
      items:
        type: array
        items: File

  r2:
    type:
      type: array
      items:
        type: array
        items: File

outputs:
  - id: sample_flat
    type:
      name: sample_flat
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

expression: |
  ${
     var sample_flat = {};
     for(var key in inputs.sample){
       sample_flat[key] = inputs.sample[key];
     }
     sample_flat["R2"] = inputs.r2;
     sample_flat["R1"] = inputs.r1;
     return { "sample_flat": sample_flat };
   }

requirements:
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  MultipleInputFeatureRequirement: {}
