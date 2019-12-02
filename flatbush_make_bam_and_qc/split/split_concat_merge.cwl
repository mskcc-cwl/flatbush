class: Workflow
cwlVersion: v1.0
id: split_concat_merge
label: split_concat_merge
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

outputs:
  split_tumor_sample:
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
    outputSource: merge_tumor/sample_flat

  split_normal_sample:
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
    outputSource: merge_normal/sample_flat

steps:
  get_sample_records:
    in:
      tumor_sample: tumor_sample
      normal_sample: normal_sample
    out: [ tumor_r1, tumor_id, tumor_r2, normal_r1, normal_id, normal_r2 ]
    run:
        class: ExpressionTool
        id: get_sample_records
        inputs:
          tumor_sample:
            type:
              type: record
              fields:
                ID: string
                R1: File[]
                R2: File[]
          normal_sample:
            type:
              type: record
              fields:
                ID: string
                R1: File[]
                R2: File[]
        outputs:
          tumor_r1: File[]
          tumor_r2: File[]
          tumor_id: string
          normal_r1: File[]
          normal_r2: File[]
          normal_id: string
        expression: "${ var sample_object = {};
            sample_object['tumor_r1'] = inputs.tumor_sample.R1;
            sample_object['tumor_r2'] = inputs.tumor_sample.R2;
            sample_object['normal_r1'] = inputs.normal_sample.R1;
            sample_object['normal_r2'] = inputs.normal_sample.R2;
            sample_object['tumor_id'] = inputs.tumor_sample.ID;
            sample_object['normal_id'] = inputs.normal_sample.ID;
            return sample_object;
          }"


  split_tumor_r1:
    in:
      fastq_file: get_sample_records/tumor_r1
      sample_id:  get_sample_records/tumor_id
      r_index:
        valueFrom: ${ return "1" }
    scatter: [ fastq_file ]
    scatterMethod: dotproduct
    out: [ split_lanes ]
    run: splitFastq.cwl 
  
  split_tumor_r2:
    in:
      fastq_file: get_sample_records/tumor_r2
      sample_id:  get_sample_records/tumor_id
      r_index:
        valueFrom: ${ return "2" }
    scatter: [ fastq_file ]
    scatterMethod: dotproduct
    out: [ split_lanes ]
    run: splitFastq.cwl 
  
  split_normal_r1:
    in:
      sample: normal_sample
      fastq_file: get_sample_records/normal_r1
      sample_id:  get_sample_records/normal_id
      r_index:
        valueFrom: ${ return "1" }
    scatter: [ fastq_file ]
    scatterMethod: dotproduct
    out: [ split_lanes ]
    run: splitFastq.cwl 

  split_normal_r2:
    in:
      sample: normal_sample
      fastq_file: get_sample_records/normal_r2
      sample_id:  get_sample_records/normal_id
      r_index:
        valueFrom: ${ return "2" } 
    scatter: [ fastq_file ]
    scatterMethod: dotproduct
    out: [ split_lanes ]
    run: splitFastq.cwl 

  merge_tumor:
    run: concat_lanes.cwl
    in:
      sample: tumor_sample
      r1: split_tumor_r1/split_lanes
      r2: split_tumor_r2/split_lanes
    out: [ sample_flat ]

  merge_normal:
    run: concat_lanes.cwl
    in:
      sample: normal_sample
      r1: split_normal_r1/split_lanes
      r2: split_normal_r2/split_lanes
    out: [ sample_flat ]

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
