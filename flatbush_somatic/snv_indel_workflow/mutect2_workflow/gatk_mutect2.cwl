class: CommandLineTool
cwlVersion: v1.0
id: gatk_mutect2
baseCommand:
  - gatk
  - Mutect2
inputs:
  - id: genomeFile
    type: File
    inputBinding:
      position: 0
      prefix: '--reference'
    doc: Input genome file
  - id: intervalFile
    type: File
    inputBinding:
      position: 0
      prefix: '--intervals'
    doc: Interval bed file
  - id: bamTumor
    type: File
    inputBinding:
      position: 0
      prefix: '--input'
    doc: Tumor BAM
  - id: idTumor
    type: string?
    inputBinding:
      position: 0
      prefix: '--tumor-sample'
  - id: bamNormal
    type: File
    inputBinding:
      position: 0
      prefix: '--input'
    doc: Normal BAM
  - id: idNormal
    type: string?
    inputBinding:
      position: 0
      prefix: '--normal-sample'
outputs:
  - id: mutect2Vcf
    doc: Output mutect2 VCF
    type: File
    outputBinding:
      glob: ${ return inputs.idTumor + "__" + inputs.idNormal + "_" + inputs.intervalFile.basename + ".vcf.gz"; }
arguments:
  - position: 0
    prefix: '--output'
    valueFrom: ${ return inputs.idTumor + "__" + inputs.idNormal + "_" + inputs.intervalFile.basename + ".vcf.gz"; }
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
  - class: ScatterFeatureRequirement
