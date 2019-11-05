class: Workflow
cwlVersion: v1.0
id: create_tn_pair

inputs:
  tumor_sample_name: 
    type: string

  normal_sample_name:
    type: string

outputs:
  samples_file:
    type: File
    outputSource: createTNPair/pairfile

steps:
  createTNPair:
      in:
         tumor_sample_name: tumor_sample_name
         normal_sample_name: normal_sample_name
         echoString:
             valueFrom: ${ return inputs.tumor_sample_name + "\ttumor\n" + inputs.normal_sample_name + "\tcontrol"; }
         output_filename:
             valueFrom: ${ return "tn_pair.txt"; }
      out: [ pairfile ]
      run:
          class: CommandLineTool
          baseCommand: ['echo', '-e']
          id: create_TN_pair
          stdout: $(inputs.output_filename)

          requirements:
              InlineJavascriptRequirement: {}
              MultipleInputFeatureRequirement: {}
              DockerRequirement:
                  dockerPull: alpine:3.8
          inputs:
              echoString:
                  type: string
                  inputBinding:
                      position: 1
              output_filename: string
          outputs:
              pairfile:
                  type: stdout

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
