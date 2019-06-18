cwlVersion: v1.0
class: CommandLineTool

label: "bamstats: BAM alignment statistics per reference sequence"

baseCommand: bamstats

inputs:

  bamFile:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    inputBinding:
      position: 1

  tsvOutput:
    type: string
    inputBinding:
      position: 2

outputs:

  tsvOutput:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.tsvOutput)

