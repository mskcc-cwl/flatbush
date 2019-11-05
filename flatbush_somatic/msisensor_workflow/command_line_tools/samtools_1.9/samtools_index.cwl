class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - samtools
  - index
inputs:
  - id: input_bam
    type: 'File'
    inputBinding:
      position: 2
      valueFrom: $(self.basename)
    doc: Input bam
arguments:
  - position: 3
    valueFrom: $(inputs.input_bam.basename.replace('.bam', '.bam.bai'))
outputs:
  - id: bam_index
    type: File
    outputBinding:
      glob: '*.bam'
    secondaryFiles:
      - .bai
requirements:
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 4
  - class: DockerRequirement
    dockerPull: 'biocontainers/samtools:v1.9-4-deb_cv1'
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.input_bam)
'dct:contributor':
  'foaf:mbox': 'mailto:bolipatc@mskcc.org'
  'foaf:name': C. Allan Bolipata
'dct:creator':
  'foaf:mbox': 'mailto:bolipatc@mskcc.org'
  'foaf:name': C. Allan Bolipata
