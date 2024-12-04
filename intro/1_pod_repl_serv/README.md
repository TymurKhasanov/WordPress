# Pod

## 1. Create a Pod

```bash
kubectl apply -f pod-ngix.yaml
```

Cheack the creation of the pod:

```bash
kubectl get pod
```

The result will be:

```bash
NAME      READY     STATUS              RESTARTS   AGE
app-nginx   0/1       ContainerCreating   0          2s
```

After a while, it will go into the  `Running` state
and the command ootput `kubectl get po` will look like this:

```bash
NAME      READY     STATUS    RESTARTS   AGE
app-nginx    1/1       Running   0          59s
```

## 2. Pod Scaling

Open the `pod-ngix.yaml` file:

```bash
vim pod-ngix.yaml
```

Change the line:

```diff
-  name: app-nginx
+  name: app-nginx-1
```

Save and exit.

Create the another pod:

```bash
kubectl apply -f pod-ngix.yaml
```

Check the result:

```bash
kubectl get pod
```

The result will be:

```bash
NAME      READY     STATUS    RESTARTS   AGE
app-nginx    1/1       Running   0          10m
app-nginx-1  1/1       Running   0          59s
```


Check the pods description:

```bash
kubectl describe pod app-nginx
```
```bash
kubectl describe pod app-nginx-1
```

## 3. Clean up the cluster

Run the command:

```bash
kubectl delete pod --all
```
