

# ISTIO
  cd ~/tools/istio-1.0.2

  helm install install/kubernetes/helm/istio --name istio --namespace istio-system --set gateways.istio-ingressgateway.type=NodePort --set gateways.istio-egressgateway.type=NodePort

  ## make istio injection automatic for PODS in dev
      kubectl label namespace dev istio-injection=enabled
      kubectl label namespace prod istio-injection=enabled

INGRESS Gateway

see:
  https://medium.com/firehydrant-io/understanding-istio-ingress-7b7b23e288d9

## add the httpbin

  kubectl apply -f <(istioctl kube-inject -f samples/httpbin/httpbin.yaml)

## Ingress PORTS

  export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
  export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
  export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o 'jsonpath={.items[0].status.hostIP}')
  env | grep INGRESS

  SECURE_INGRESS_PORT=31390
  INGRESS_HOST=192.168.10.221
  INGRESS_PORT=31380


## GATEWAY

  cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: httpbin-gateway
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "httpbin.example.com"
EOF


## Define the traffic rules
cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: httpbin
spec:
  hosts:
  - "httpbin.example.com"
  gateways:
  - httpbin-gateway
  http:
  - match:
    - uri:
        prefix: /status
    - uri:
        prefix: /delay
    route:
    - destination:
        port:
          number: 8000
        host: httpbin
EOF


http://localhost:15000/config_dump

kubectl get pod -n istio-system -l istio=ingressgateway -o name
kubectl -n istio-system port-forward pod/istio-ingressgateway-699794bf9c-p2bpm 80


curl -I -HHost:httpbin.example.com http://$INGRESS_HOST:$INGRESS_PORT/status/200
