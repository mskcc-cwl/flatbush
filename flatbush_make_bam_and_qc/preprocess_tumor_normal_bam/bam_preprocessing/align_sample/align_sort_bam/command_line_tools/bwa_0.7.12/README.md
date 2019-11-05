# CWL and Dockerfile for running bwa (http://bio-bwa.sourceforge.net/)

## Version of tools in docker image (/container/Dockerfile)

| Tool  | Version       | Location      |
|---    |---    |---    |
| bwa     | 0.7.12        |   -   |

## CWL

- CWL specification 1.0
- Use example_inputs_toolname.yaml to see the inputs to the cwl
- Example Command using [toil](https://toil.readthedocs.io):

```bash
    > toil-cwl-runner bwa_mem.cwl inputs.yaml
```

