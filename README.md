# BARE METAL Kubernetes cluster for OpenStack

# Minimal Terraform OTC Example

This script will create the following resources:

* Floating IPs
* Neutron Ports
* Instances
* Keypair
* Network
* Subnet
* Router
* Router Interface
* Security Group (Allow ICMP, 80/tcp, 22/tcp)

# What it does:

At first it creates an infrastructure using terraform.
Terraform also writes an inventory file for ansible.  
The variables regarding the infrastructure/terraform  are found in `variables.tf`.

Don't touch `instances` as it would start multiple masters. Right now
only one master is supported.

You should change `ssh_pub_key`. As for sure it is the wrong key in it ;)

`worker_count` and `flavor_name` are the one you would like to set.

Right now K8s 1.9.3 is installed.


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

### Ansible Kubernetes clsuter install

    ansible-playbook -i ini play.yml

Note: ssh ubuntu@80.158.6.125 for the ssh keys problem

    ansible-playbook -i ini play.yml

### Install kubectl on your machine

    https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-using-curl

## Define env variale kubeconfig

  export KUBECONFIG=/home/antonio/core/devops/terraform/clusterfiles/cluster-admin/kubeconfig.yml

## Install sw packages

    k create -f deployfiles/10-kube-system-serviceaccount.yml
    k create -f deployfiles/20-kube-proxy.yaml
    k create -f deployfiles/22-kube-dns-all.yaml
    k create -f deployfiles/30-canal.yaml
    k create -f deployfiles/40-heapster.yaml

## Check installation

    kubectl cluster-info
    kubectl config view --raw
    kubectl get nodes

    wait.....all nodes ready

# Copy content of clusterfiles/cluster-admin into spring boot apps

    // todo make it automatic somehow...

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

##  Kubernetes dashboard
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
    kubectl apply -f dashboard-user.yaml
    kubectl get sa admin-user -n kube-system
    kubectl describe sa admin-user

        grab the mountable secret:
            Mountable secrets:      admin-user-token-9rstp

    kubectl get secrets admin-user-token-kd65z
    kubectl describe secrets admin-user-token-kd65z -n kube-system

    token:          
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWtkNjV6Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJhZTViYTVkZi1jMjMwLTExZTgtYThmMC1mYTE2M2U2Mjc1OWQiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.XxdtU2h-m2k8Gxl7fXnC55EuPEqjp5dbqOepcF1iytMEO676JeV-g4U4OiU-MaEOBpNvq3Shs5Vkx0ODRZtYYJuIO9mWwgwhYGb9ZpB-Uj2g7PoeLKVZ8V3FeCB16kFPL6HqRjCRrRoY0XHBhdufEshqHFdNIkBrB2fpthgEooKlwDYkabQkZQxvPP5UDZn44RVf9UTYDt1QCRzFPaf_RIJ22BSZehTzSgIsnanYL3aETrVOtnTSqAObaIE6yluH_qtctYx9fg7l1DyuaoEp-LVxn2a6pFCnVRFfO4nZBN14m--cFUJXUgm4VQDc06wjRZLGM1CYtckSxf7d1GvPHkBMHw_w23aUf4LWNOKhOAqrNuD_pqOaLywZm6iFZj-T9GqWSKCnazKfwYnhroXZQVZuqJhTRRdLuMX6IQV_59dAiJ2u4QONiGJRbO6aBw48m68QHcPWu1iLwRwFCJVbp198yJ8XbQorA64X2hG2CR3FUqNiwAwWYKCxyxGOVVo7yG0tJYzou0R2f0PeG2Dlg41QrRQv7LRBFBoqDV05jLghqwGx_it3AYW97xiRoeyIWyGv-UF2PF9SklQItojPoHDhqCn-_2s457vidTByK0PmiHCMPhRUyku3NcF47JLAobwow_RtONzreaGvBQTPiQ_jAaWkAZ4gRJ8YDul60uc

    kubectl proxy
    firefox http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/


    antonio@antonio:~/core/devops/terraform$ k get pods
    NAME                                    READY     STATUS    RESTARTS   AGE
    canal-6cgv6                             3/3       Running   0          1m
    canal-7tnnq                             3/3       Running   0          1m
    canal-kt8wk                             3/3       Running   0          1m
    canal-pcw7b                             3/3       Running   0          1m
    canal-s9nw8                             3/3       Running   0          1m
    canal-z5ww8                             3/3       Running   0          1m
    heapster-v1.4.1-dfdf9c6b7-gmrc9         2/2       Running   0          1m
    kube-dns-2fpv7                          3/3       Running   0          1m
    kube-proxy-gn5rg                        1/1       Running   0          1m
    kube-proxy-kfhgs                        1/1       Running   0          1m
    kube-proxy-lnnld                        1/1       Running   0          1m
    kube-proxy-mq5k4                        1/1       Running   0          1m
    kube-proxy-rxb99                        1/1       Running   0          1m
    kube-proxy-wln7z                        1/1       Running   0          1m
    kubernetes-dashboard-6c664cf6c5-4kjw8   1/1       Running   0          21m
    tiller-deploy-9bdb7c6bc-fhsvr           1/1       Running   0          33m



# Create DEV, QA, PROD namespace (environment)

    cat <<EOF | kubectl create -f -
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

    cat <<EOF | kubectl create -f -
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

    cat <<EOF | kubectl create -f -
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

# PUT  Docker Hub secrets into develop namespace  to pull docker images from docker.hub

kubectl create secret docker-registry regcred --docker-username=asignore --docker-password=********** --docker-email=***************** -n develop

## Istio

    cd istio-1.0.2
    helm install install/kubernetes/helm/istio --name istio --namespace istio-system

## make istio injection automatic for PODS in dev

  kubectl label namespace develop istio-injection=enabled

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
      namespace: develop
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
      labels:
        app: myhelloworld
      name: myhelloworld
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: myhelloworld
        spec:
          containers:
          - image: stevenc81/jaeger-tracing-example:0.1
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
      labels:
        app: myhelloworld
        namespace: dev
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
      annotations:
        kubernetes.io/ingress.class: "istio"
    spec:
      rules:
      - http:
          paths:
          - path: /
            backend:
              serviceName: myhelloworld
              servicePort: 80
          - path: /gettime
            backend:
              serviceName: myhelloworld
              servicePort: 8
    EOF
