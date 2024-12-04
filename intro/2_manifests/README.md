# Config map

nginx.conf

kubectl create configmap nginx-config --from-file=manifests/nginx.conf

kubectl get configmap nginx-config -o yaml
