# CWLs for running commands in delly_v0.8.1
CWLs for Delly v0.8.1

## Sub-commands

- `delly_filter.cwl`
- `delly_call.cwl`
- `create_tn_pair.cwl`

## Version of tools

| Tool	| Version	| Location	| Image Digest	|
|--|--|--|--|
| delly	| v0.8.1	| https://github.com/dellytools/delly/tree/v0.8.1	| [cmopipeline/delly:v0.8.1](https://hub.docker.com/layers/cmopipeline/delly/v0.8.1/images/sha256-28fe6e8ca6003a5b1ef89dba4d90ba89aa68d5579132726fb28dae7edcf0656b) 	|

## Explanation of CWLs

`delly_filter.cwl` and `delly_call.cwl` are used for Somatic and Germline SV Calling; for more detailed usage information, see https://github.com/dellytools/delly/tree/v0.8.1#running-delly

`create_tn_pair.cwl` is a helper CWL that creates a pairing text file needed by `delly filter`. Note that it only supports one tumor/normal pair. This CWL is used usually in a pipeline, such as [delly workflow](https://github.com/mskcc-cwl/delly_workflow).

## CWL Usage Examples

- CWL specification 1.0
- Use the corresponding example input YAML as a template.
- Example Command using [toil](https://toil.readthedocs.io):

```bash
# delly call
    > toil-cwl-runner delly_call.cwl inputs_delly_call.yaml

# delly filter
    > toil-cwl-runner delly_filter.cwl inputs_delly_filter.yaml

```
