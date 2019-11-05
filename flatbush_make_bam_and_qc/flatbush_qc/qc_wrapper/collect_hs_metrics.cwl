#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: CommandLineTool
id: collect_hs_metrics 

baseCommand: [ 'python3', '/opt/tempo/scripts/run_hsmetrics.py' ]

arguments:
- position: 0
  prefix: --TMP_DIR
  valueFrom: .

requirements:
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    ramMin: 16000
    coresMin: 1
  DockerRequirement:
    dockerPull: mskcc/tempo_qc:0.1.0

doc: |
  This is a CWL that wraps a call to CollectHsMetrics  

inputs:
  INPUT:
    type: File
    inputBinding:
      prefix: --INPUT
      position: 2
    secondaryFiles:
      - ^.bai
      
  BAIT_INTERVALS:
    type: File?
    doc: An interval list file that contains the locations of the baits used. Default
      value - null. This option must be specified at least 1 times.
    inputBinding:
      prefix: --BAIT_INTERVALS
      position: 2
      
  TARGET_INTERVALS:
    type: File?
    doc: An interval list file that contains the locations of the targets. Default
      value - null. This option must be specified at least 1 times.
    inputBinding:
      prefix: --TARGET_INTERVALS
      position: 2
      
  OUTPUT:
    type: string
    doc: The output file to write the metrics to. Required.
    inputBinding:
      prefix: --OUTPUT
      position: 2
      
  REFERENCE_SEQUENCE:
    type: File
    inputBinding:
      prefix: --REFERENCE_SEQUENCE
      position: 2
    secondaryFiles:
      - .fai
      - ^.dict

  mem_option:
    type: string?
    doc: If provided, adds a memory setting for the java jar command '-Xmx $(mem_option)g'
    inputBinding:
      prefix: --mem_option
      position: 2

outputs:
  out_file:
    type: File
    outputBinding:
      glob: |
        ${
          if (inputs.OUTPUT)
            return inputs.OUTPUT;
          return null;
        }
