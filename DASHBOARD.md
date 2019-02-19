##  Kubernetes dashboard
    k apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
    k apply -f dashboard-user.yaml
    k get sa admin-user -n kube-system
    k describe sa admin-user

        grab the mountable secret:
            Mountable secrets:      admin-user-token-br25g

    k get secrets admin-user-token-br25g
    k describe secrets admin-user-token-br25g -n kube-system

    token:          
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLWJyMjVnIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI2YWZmNDI4Yy1kMjBkLTExZTgtYmJmNy1mYTE2M2U3ZTFhMjUiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZS1zeXN0ZW06YWRtaW4tdXNlciJ9.Von_urx1DDFhw_NXBdCRKPxIMcuiSF-hNmTAHCyQUf3ahKhEMLSBaPS_Ml6HvQRFH_N-CaC8MOO-wqs3u7xKxYyyTJjNy6fTTjx957BEeNmYZyf5uHtEACnEpYDxaP3wCeCLv4XZ-KX-7IkENRoOcCrj-Wa45c9F4lUj2hrqV1Ou4iwxQHtHk3_5kMbMN6NOu10OaWqqQ2V-JYbfF00M9UEPYMPO3_Y28aCzeVPTKGLfOICJBgg0_LdSaHKhlgX-g0AaskAAxZ7EQqJfMgFLpbNfaeC9Kr1RSNWqq9Ht8jZiu3CePZbj5HtyGAxHUbJTbtyDhGMMve6hkVXthbzJU_dOD3p4rE6czm2rPHKA0QNtfflai5fEpTisSskNeOY9NC7KrsRq9sQRcdIkUbwNfQbH6waAOzlIHx9arcFV7QoP9a_DCLht2_VzEc9ZFwxDALV9jHzDCzsla2SjqnJ07y-xLh2eNI31Fh2c0rFAH9IEmCIWMULWYSNPG4Yfv2LzDvlv1RpoJePmcp19OOcWN4t2IxkEqhtsNH9yXN6Um3hAaRXscs1ndLJuJIloyCmVdx6gT8JJ8GFAZbY-2ANyGc33-_AQKJseglaVnfQLCaPwJabxQ5rIs8VM1tmWmRR75mQCtuKrF7WQJMm1cNa_9t89Idi4g0HM2ppbUg9w2L4

    k proxy
    firefox http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/



    firefox http://localhost:8001/api/v1/namespaces/develop/services/https:core-test:/proxy/
