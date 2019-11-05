cwlVersion: v1.0

class: CommandLineTool
baseCommand: [ '/bin/bash', '/usr/local/bin/run_delly_filter.sh' ] # workaround for singularity <= 3.3.0
id: delly_filter

requirements:
  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: mskcc/delly:v0.8.1
  ResourceRequirement:
    ramMin: 4000
    coresMin: 1

arguments:
  - position: 1
    valueFrom: somatic

inputs:
  call_bcf_file:
    type: File
    inputBinding:
      position: 4
    secondaryFiles:
      - .csi

  samples: 
    type: File
    inputBinding:
      position: 2

  outfile:
    type: string
    inputBinding:
      position: 3

outputs:
  output:
    type: File
    secondaryFiles:
      - .csi
    outputBinding:
      glob: |
        ${
          if(inputs.outfile)
            return inputs.outfile;
          return null
        }
