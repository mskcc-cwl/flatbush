class: CommandLineTool
cwlVersion: v1.0
id: split
label: split

baseCommand: [ 'python', '/home/reza/flatbush/flatbush_make_bam_and_qc/split/split_lanes.py' ]

inputs:      
  fastq_file:
    type: File
    inputBinding:
      prefix: '--fastq_file'
      position: 0  

  sample_id:
    type: string
    inputBinding:
      prefix: '--sample_id'
      position: 0

  output_fize_size_name:
    type: string?
    default: "file_size.txt"
    inputBinding:
      prefix: '--file_size_name'
      position: 0

  r_index:
    type: string
    inputBinding:
      prefix: "--r_index"
      position: 0

outputs:
  split_lanes:
    type:
      type: array
      items: File
    outputBinding:
      glob: '*splitLanes.fastq.gz'

requirements:
  DockerRequirement:
    dockerPull: 'mskcc/split-fastq-lanes:1.0'
