class: Workflow
cwlVersion: v1.0
id: run_delly
label: run_delly 

inputs:
  bam_normal:
    type: File
    secondaryFiles:
      - ^.bai

  bam_tumor:
    type: File
    secondaryFiles:
      - ^.bai

  id_tumor:
    type: string

  id_normal:
    type: string

  genome:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict

  exclude:
    type: File

  svtype:
    type: string[]
 
outputs:
  delly_call_output:
    type: File[]
    outputSource: delly_call/output
    secondaryFiles:
      - .csi

  delly_filtered_output:
    type: File[]
    outputSource: delly_filter_somatic/output
    secondaryFiles:
      - .csi

steps:
  delly_call:
    in:
      tumor_sample_name: id_tumor
      normal_sample_name: id_normal
      bam_normal: bam_normal
      bam_tumor: bam_tumor
      genome: genome
      exclude: exclude
      svtype: svtype
      outfile:
        valueFrom: ${ return inputs.tumor_sample_name + "_" + inputs.normal_sample_name + "." + inputs.svtype + ".bcf" }
    out: [ output ]
    scatter: [ svtype ]
    scatterMethod: dotproduct
    run: command_line_tools/delly_v0.8.1/delly_call.cwl

  create_tn_pair:
    in:
      tumor_sample_name: id_tumor
      normal_sample_name: id_normal
    out: [ samples_file ]
    run: command_line_tools/delly_v0.8.1/create_tn_pair.cwl

  delly_filter_somatic:
    in:
      call_bcf_file: delly_call/output
      samples: create_tn_pair/samples_file
      outfile: 
        valueFrom: ${ return inputs.call_bcf_file.basename.replace(".bcf", ".filtered.bcf"); }
    out: [ output ]
    scatter: [ call_bcf_file ]
    scatterMethod: dotproduct
    run: command_line_tools/delly_v0.8.1/delly_filter_somatic.cwl

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
