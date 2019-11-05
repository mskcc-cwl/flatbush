# CWL and Dockerfile for running MSISensor v0.5

## Version of tools in docker image

| Tool	| Version	| Location	|
|---	|---	|---	|
| vanallenlab/msisensor  	| 0.5  	|  https://hub.docker.com/layers/vanallenlab/msisensor/0.5/images/sha256-1bfc273da836c736d088f83597370e4f39e46aa1d44a94e8e397825dfa9132ab	|

## CWL

- CWL specification 1.0
- Example Command using [toil](https://toil.readthedocs.io):

```bash
    > toil-cwl-runner msisensor.cwl <inputs YAML file>
```
