# Optional Debugging Lab - Tips and Tricks for Debugging Applications in Kubernetes

Advanced debugging techniques to reach your pods.

## Pod Logs

You can look at the logs of any of the pods running under your deployments as follows

```shell
$ kubectl logs <podname>
```

Remember that if you have multiple containers running in your pod, you
have to specify the specific container you want to see logs from.

```shell
$ kubectl logs <pod-name> <container-name>
```

This subcommand operates like `tail`. Including the `-f` flag will
continue to stream the logs live once the current time is reached.


## kubectl edit and vi

By default, on many Linux and macOS systems, you will be dropped into the editor `vi`.
```
export EDITOR=nano
```

On Windows, a copy of `notepad.exe` will be opened with the contents of the file.

## busybox pod

For debugging live, this command frequently helps me:
```shell
kubectl create deployment bb --image busybox --restart=Never -it --rm
```

In the busybox image is a basic shell that contains useful utilities.

Utils I often use are `nslookup` and `wget`. 

`nslookup` is useful for testing DNS resolution in a pod.

`wget` is useful for trying to do network requests.

## Service Endpoints

Endpoint resource can be used to see all the service endpoints.
```shell
$ kubectl get endpoints <service>
```

## ImagePullPolicy

By default Kubernetes will only pull the image on first use. This can
be confusing during development when you expect changes to show up.

You should be aware of the three `ImagePullPolicy`s:
 - IfNotPresent - the default, only request the image if not present.
 - Always - always request the image.
 - Never

More details on image management may be [found here](https://kubernetes.io/docs/concepts/containers/images/).
