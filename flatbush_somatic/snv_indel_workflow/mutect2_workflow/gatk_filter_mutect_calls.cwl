class: CommandLineTool
cwlVersion: v1.0
id: gatk_filter_mutect_calls
baseCommand:
  - gatk
  - FilterMutectCalls
inputs:
  - id: mutect2Vcf
    type: File
outputs:
  - id: filteredMutect2Vcf
    doc: Output filtered mutect2 VCF
    type: File
    outputBinding:
      glob: $(inputs.mutect2Vcf.basename.replace('.vcf.gz', '')).filtered.vcf.gz
arguments:
  - position: 0
    prefix: '--variant'
    valueFrom: $(inputs.mutect2Vcf)
  - position: 0
    prefix: '--stats'
    valueFrom: $(inputs.mutect2Vcf.basename.replace('.vcf.gz', '')).Mutect2FilteringStats.tsv
  - position: 0
    prefix: '--output'
    valueFrom: $(inputs.mutect2Vcf.basename.replace('.vcf.gz', '')).filtered.vcf.gz
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
