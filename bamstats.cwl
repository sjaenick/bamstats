cwlVersion: v1.0
class: CommandLineTool

hints:   
  DockerRequirement:     
    dockerPull: sjaenick/bamstats

label: "bamstats: BAM alignment statistics per reference sequence"

baseCommand: bamstats

inputs:

  bamFile:
    type: File
    format: http://edamontology.org/format_2572 # BAM
    inputBinding:
      position: 1

arguments:
  - position: 2
    valueFrom: |
      ${
        return inputs.bamFile.nameroot + ".tsv"
      }

outputs:

  tsvOutput:
    type: File
    format: http://edamontology.org/format_3475 # TSV
    outputBinding:
      glob: $(inputs.bamFile.nameroot + ".tsv")

