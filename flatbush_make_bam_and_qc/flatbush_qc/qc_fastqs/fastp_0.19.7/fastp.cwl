cwlVersion: v1.0

class: CommandLineTool
baseCommand: [fastp]
id: fastp

requirements:

  InlineJavascriptRequirement: {}
  DockerRequirement: 
    dockerPull: mskcc/fastp:0.19.7
  ResourceRequirement:
    ramMin: 16000
    coresMin: 2

doc: |
  Run fastp on a pair of fastq files

inputs:
  html:
    type: string
    inputBinding:
      prefix: --html

  json:
    type: string
    inputBinding:
      prefix: --json

  in1:
    type: File
    inputBinding:
      prefix: --in1

  in2:
    type: File
    inputBinding:
      prefix: --in2

outputs:
  html_output:
    type: File
    outputBinding:
      glob: ${ return inputs.html; }

  json_output:
    type: File
    outputBinding:
      glob: ${ return inputs.json; }
