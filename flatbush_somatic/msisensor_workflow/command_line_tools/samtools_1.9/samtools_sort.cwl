class: CommandLineTool
cwlVersion: v1.0

baseCommand:
  - samtools
  - sort
inputs:
  input_bam:
    type: 'File'
    inputBinding:
      position: 3
    doc: Input bam
  o:
    type: string
    inputBinding:
      position: 2
      prefix: '-o'
    doc: Output file name
outputs:
  bam_sorted:
    type: File
    outputBinding:
      glob: |
        ${
          if(inputs.o)
            return inputs.o;
          return null;
        }
requirements:
  - class: ResourceRequirement
    ramMin: 32000
    coresMin: 4
  - class: DockerRequirement
    dockerPull: 'biocontainers/samtools:v1.9-4-deb_cv1'
  - class: InlineJavascriptRequirement
'dct:contributor':
  'foaf:mbox': 'mailto:bolipatc@mskcc.org'
  'foaf:name': C. Allan Bolipata
'dct:creator':
  'foaf:mbox': 'mailto:bolipatc@mskcc.org'
  'foaf:name': C. Allan Bolipata
