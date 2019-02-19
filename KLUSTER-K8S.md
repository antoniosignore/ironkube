## Build the infrastructure

### Clean older infrastructure

    terraform destroy

### Clean older keys
        ./clean.sh

### plan and build infrastructure
    terraform plan
    terraform apply

### Expected result

Generated the 'ini' initialization file for Ansible

### Ansible
    ansible-playbook -i ini play.yml


## Environment security_group_ids

Add these definition in your .bashrc to simplify a bit yor typing (k insteal of kubectl)

  export KUBECONFIG=terraform/clusterfiles/cluster-admin/kubeconfig.yml
  alias k="/usr/bin/kubectl"

## install k8s apps
    k create -f deployfiles/10-kube-system-serviceaccount.yml
    k create -f deployfiles/20-kube-proxy.yaml
    k create -f deployfiles/22-kube-dns-all.yaml
    k create -f deployfiles/30-canal.yaml
    k create -f deployfiles/40-heapster.yaml

## Check installation

    k cluster-info
    k cluster-info dump

## Install HELM
    helm init
    k get pods --namespace kube-system
    helm init --upgrade
    k create serviceaccount --namespace kube-system tiller
    k create clusterrolebinding tiller-cluster-rule \
       --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    k patch deploy --namespace kube-system tiller-deploy \
       -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
    helm repo update   


    # Create DEV, QA, PROD namespace (environment)
    cat <<EOF | k create -f -
    {
      "kind": "Namespace",
      "apiVersion": "v1",
      "metadata": {
        "name": "develop",
        "labels": {
          "name": "develop"
        }
      }
    }
    EOF

    cat <<EOF | k create -f -
    {
      "kind": "Namespace",
      "apiVersion": "v1",
      "metadata": {
        "name": "staging",
        "labels": {
          "name": "staging"
        }
      }
    }
    EOF

    cat <<EOF | k create -f -
    {
      "kind": "Namespace",
      "apiVersion": "v1",
      "metadata": {
        "name": "production",
        "labels": {
          "name": "production"
        }
      }
    }
    EOF






# INGRESS NGINX
apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class: nginx
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /






# PUT image from Docker Hub into dev namespace  

  kubectl create secret docker-registry regcred --docker-username=asignore --docker-password=ansi500urk36x --docker-email=ansi500urk36x -n dev


cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Service
metadata:
  name: sentiment-analysis-web-app
  labels:
    app: sentiment-analysis-web-app
spec:
  ports:
  - port: 80
    name: http
  selector:
    app: sentiment-analysis-web-app
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: sentiment-analysis-web-app
  namespace: dev
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: sentiment-analysis-web-app
    spec:
      containers:
      - name: private-reg-container-name
        image: asignore/sentiment-analysis-web-app
      imagePullSecrets:
      - name: regcred
EOF


# Hello world in ISTIO dev environment
cat <<EOF | kubectl create -f -
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: myhelloworld
  namespace: dev
  labels:
    app: myhelloworld
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: myhelloworld
    spec:
      containers:
      - image: gcr.io/google-samples/hello-app:1.0
        imagePullPolicy: Always
        name: myhelloworld
        ports:
        - containerPort: 8080
      restartPolicy: Always
---
apiVersion: v1
kind: Service
metadata:
  name: myhelloworld
  namespace: dev
  labels:
    app: myhelloworld
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8080
    name: http
  selector:
    app: myhelloworld
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: myhelloworld
  namespace: dev
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: antonio.com
    http:
      paths:
      - path: /
        backend:
          serviceName: myhelloworld
          servicePort: 80
      - path: /gettime
        backend:
          serviceName: myhelloworld
          servicePort: 80
status:
  loadBalancer:
    ingress:
    - {}
EOF


cat <<EOF | kubectl create -f -
apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    annotations:
      kubernetes.io/ingress.class: nginx
    name: example
    namespace: foo
  spec:
    rules:
      - host: www.example.com
        http:
          paths:
            - backend:
                serviceName: exampleService
                servicePort: 80
              path: /

#   Docker app and expose to Internet

Create a Deployment using the sample web application container image that listens on a HTTP server on port 8080:
Create a Service resource to make the web deployment reachable within your container cluster:
Verify the Service was created and a node port was allocated:
Create an Ingress resource : basic-ingress-resource:

k run web --image=gcr.io/google-samples/hello-app:1.0 --port=8080
k expose deployment web --target-port=8080 --type=NodePort
k get service web    
cat <<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: basic-ingress
spec:
  backend:
    serviceName: web
    servicePort: 8080
EOF

  firefox http://localhost:8001/api/v1/namespaces/kube-system/services/http:web:/proxy/


  #   Docker.io app and expose to Internet

  Create a Deployment using the sample web application container image that listens on a HTTP server on port 8080:
  Create a Service resource to make the web deployment reachable within your container cluster:
  Verify the Service was created and a node port was allocated:
  Create an Ingress resource : basic-ingress-resource:

kubectl run trader --image=asignore/trader:latest --port=8080
kubectl expose deployment trader --target-port=8080 --type=NodePort
kubectl get service trader    
cat <<EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: trader-ingress
spec:
  backend:
    serviceName: trader
    servicePort: 8080
EOF

kubectl proxy
firefox http://localhost:8001/api/v1/namespaces/kube-system/services/http:trader:/proxy/


ACCESS THE SERVICES
    kubectl get svc istio-ingressgateway -n istio-system

# Monitoring (deprecated)
Install all the tools to namespace 'monitoring'
kubectl apply \
  --filename https://raw.githubusercontent.com/giantswarm/kubernetes-prometheus/master/manifests-all.yaml


### collect data for OTC configurarion in CodeFresh

    export CURRENT_CONTEXT=$(kubectl config current-context) && export CURRENT_CLUSTER=$(kubectl config view -o go-template="{{\$curr_context := \"$CURRENT_CONTEXT\" }}{{range .contexts}}{{if eq .name \$curr_context}}{{.context.cluster}}{{end}}{{end}}") && echo $(kubectl config view -o go-template="{{\$cluster_context := \"$CURRENT_CLUSTER\"}}{{range .clusters}}{{if eq .name \$cluster_context}}{{.cluster.server}}{{end}}{{end}}")

    echo $(kubectl get secret -o go-template='{{index .data "ca.crt" }}' $(kubectl get sa default -o go-template="{{range .secrets}}{{.name}}{{end}}"))


    echo $(kubectl get secret -o go-template='{{index .data "token" }}' $(kubectl get sa default -o go-template="{{range .secrets}}{{.name}}{{end}}"))
