class: CommandLineTool
cwlVersion: v1.0
id: gatk_split_intervals
baseCommand:
  - gatk
  - SplitIntervals
inputs:
  - id: genomeFile
    type: File
    inputBinding:
      position: 0
      prefix: '--reference'
    doc: Input genome file
  - id: agilentTargets
    type: File
    inputBinding:
      position: 0
      prefix: '--intervals'
    doc: Agilent Targets
  - id: scatterCount
    type: integer?
    inputBinding:
      position: 0
      prefix: '--scatter-count'
    doc: Scatter Count
  - id: output_dir
    type: string?
    inputBinding:
      prefix: '--output'
outputs:
  - id: split_interval_files
    doc: Output agilent
    type:
      type: array
      items: File
    outputBinding:
      glob: $(inputs.output_dir)/*
arguments:
  - position: 0
    prefix: '--subdivision-mode'
    valueFrom: BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW
  - position: 0
    prefix: '--java-options'
    valueFrom: '-Xms$(parseInt(runtime.ram)/2000)g -Xmx$(parseInt(runtime.ram)/1000)g'
requirements:
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 4
  - class: DockerRequirement
    dockerPull: 'broadinstitute/gatk:4.1.0.0'
  - class: InlineJavascriptRequirement
