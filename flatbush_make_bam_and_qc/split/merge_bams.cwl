class: CommandLineTool
cwlVersion: v1.0
id: merge_bams
label: merge_bams

baseCommand: [ samtools, merge ]

inputs:      
  cpus:
    type: int
	inputBinding:
	  prefix: "--threads"
	  position: 0

  sample_id:
    type: string
	
  bams:
    type: File[]
	inputBinding:
	  position: 2

arguments:
  - position: 1
    valueFrom: $(inputs.sample_id + ".merged.bam")

outputs:
  merged_bam:
    type:
      type: array
      items: File
    outputBinding:
      glob: '*merged.bam'

requirements:
  DockerRequirement:
    dockerPull: 'mjblow/samtools-1.9:latest'
