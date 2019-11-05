#!/usr/bin/env cwl-runner
cwlVersion: v1.0

class: ExpressionTool
id: put_files_in_dir

requirements:
  - class: InlineJavascriptRequirement

inputs:

  output_directory_name: string

  files: Any

outputs:

  directory:
    type: Directory

# This tool returns a Directory object,
# which holds all output files from the list
# of supplied input files
expression: |
  ${
    var output_files = [];
    var nonEmpty = function (s) {return String(s).toUpperCase() != 'NONE'};
    
    if(!Array.isArray(inputs.files))
       inputs.files=[inputs.files];
    
    var input_files = inputs.files.filter(nonEmpty);

    for (var i = 0; i < input_files.length; i++) {
      if(input_files[i]){
        output_files.push(input_files[i]);
      }
    }

    return {
      'directory': {
        'class': 'Directory',
        'basename': inputs.output_directory_name,
        'listing': output_files
      }
    };
  }
