Let's write a manifest for the Nginx service using `NodePort` type, which can be applied directly via `kubectl`. 
```yaml
kubectl expose deployment nginx-deployment --type=NodePort --port=80 --target-port=80
```

This manifest exposes your Nginx deployment on port 80 and assigns a `NodePort` for external access.

### Nginx Service Manifest (`nginx-service.yaml`):

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80         # The port that the service will expose
      targetPort: 80    # The port on the container where Nginx is listening
      nodePort: 30036   # Optional: Specify a NodePort, or let Kubernetes assign one automatically
```

### Steps to Apply the Service:

1. **Save the YAML Manifest**: Save the above content in a file called `nginx-service.yaml`.

2. **Apply the Service**: Use `kubectl` to apply the service manifest:

   ```bash
   kubectl apply -f nginx-service.yaml
   ```

3. **Verify the Service**: After applying the service, verify that it’s been created and check the `NodePort` assigned:

   ```bash
   kubectl get svc nginx-deployment
   ```

**Understanding NodePort Services**

NodePort services expose a service on a specific port on all nodes in your cluster. In this case, the NodePort is 30036, meaning that the service is accessible on that port on all three nodes (k3d-k3dcluster-server-0, k3d-k3dcluster-agent-0, k3d-k3dcluster-agent-1).
```
kubectl get nodes
NAME                      STATUS   ROLES                  AGE   VERSION
k3d-k3dcluster-server-0   Ready    control-plane,master   97m   v1.30.1+k3s1
k3d-k3dcluster-agent-0    Ready    <none>                 97m   v1.30.1+k3s1
k3d-k3dcluster-agent-1    Ready    <none>                 97m   v1.30.1+k3s1
```
