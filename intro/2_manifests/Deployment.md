To deploy the given Nginx deployment configuration in Kubernetes, follow these steps:

### Step 1: Save the Deployment YAML
First, save the deployment YAML into a file, for example `nginx-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
          resources:
            requests:
              memory: "64Mi"
              cpu: "250m"
            limits:
              memory: "128Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 5
            periodSeconds: 10
          volumeMounts:
            - name: nginx-config
              mountPath: /etc/nginx/nginx.conf
              subPath: nginx.conf
      volumes:
        - name: nginx-config
          configMap:
            name: nginx-config
```

### Step 2: Apply the ConfigMap
Before deploying the Nginx deployment, ensure that the ConfigMap named `nginx-config` exists, as the deployment depends on it. If you haven't already created the ConfigMap, do so:

1. Create the `nginx.conf` file:

```bash
cat <<EOF > nginx.conf
events {}
http {
    server {
        listen 80;
        location / {
            return 200 'Hello, Nginx!';
            add_header Content-Type text/plain;
        }
    }
}
EOF
```

2. Create the ConfigMap:

```bash
kubectl create configmap nginx-config --from-file=nginx.conf
```

### Step 3: Deploy the Nginx Deployment
Now that the ConfigMap is ready, deploy the Nginx deployment using the following command:

```bash
kubectl apply -f nginx-deployment.yaml
```

### Step 4: Verify the Deployment
Check if the Nginx pods are running successfully:

```bash
kubectl get pods -l app=nginx
```

You should see the Nginx pods running (you specified `replicas: 3`, so expect to see 3 pods).

### Step 5: Check the Logs and Pod Details
To further verify if everything is working correctly, you can check the logs of one of the pods:

```bash
kubectl logs <nginx-pod-name>
```

Or describe the deployment for more details:

```bash
kubectl describe deployment nginx-deployment
```

