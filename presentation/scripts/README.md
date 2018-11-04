# Instructions for Running the Presentation Demo Scripts

## The following are needed:
- `bx` executable
- `bx cs` plugin
- `docker` installed
- `kubectl`

## Prereq steps:
- Pick a name for your cluster (e.g. `osscluster`)
- Pick a name for your Registry namespace (e.g. `kube101`)
- Log into IBM Cloud: `bx login` or if you use sso: `bx login --sso`
- Log into the IBM Registry: `bx cr login`
- Create a Kubernetes cluster: `bx cs cluster-create --name osscluster`, if
  it doesn't already exist
- Create the registry namespace: `bx cr namespace-add kube101`, if it doesn't
  already exist

## Running the demo scripts

- Modify the `common.sh` file to make sure your cluster and registry
  namespace values are set properly
- Run each `sh` file as instructed in the [presentation](../Workshop.pptx)
- As the scripts are running press `ENTER` or `space` when it pauses
- If you press `f` it will remove the delay as it types
- If you press `r` it will remove the pauses. So, if you want to do both
  press `f` before you press `r`

## Cleaning up

Run `clean.sh` to clean up the environment. It does not erase your
cluster or registry namespace.

## Automated running of scripts

To run all of the script in an automated way, make sure your cluster and
registry namespace are ready and then:
```
SKIP=1 DELAY=0 ./all.sh
```

`SKIP=1` tells it to not pause at each command

`DELAY=0` tells it to not print slowly, simulating typing
