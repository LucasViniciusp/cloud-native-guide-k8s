# Kubernetes

O Kubernetes é uma plataforma de orquestração de contêineres que oferece um conjunto de APIs que permitem a automação e o gerenciamento eficiente de aplicativos em contêineres.

## :material-kubernetes: Kind Install

!!! note "Kind é uma ferramenta que permite executar clusters Kubernetes locais usando contêineres Docker"

Para praticarmos, criaremos uma pequeno cluster utilizando o [Kind (Kubernetes in Docker)](https://kind.sigs.k8s.io/) para usarmos de exemplo

!!! warning "Requirements"
    - [Docker](docker.md) Installed
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) Installed

!!! note "Installer Script"
    ```sh 
    # For AMD64 / x86_64
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-amd64
    # For ARM64
    [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-linux-arm64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    ```

## Criando um Cluster Kubernetes

!!! example "Crie um cluster executando o seguinte comando:"

    ```sh
    kind create cluster
    kubectl cluster-info
    ```

!!! tip "Para um cluster mais personalizado, use um arquivo `config.yaml` com a configuração de cluster desejada:"

    ```yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
    - role: control-plane
    - role: worker
    - role: worker
    ```

    ```sh
    kind create cluster --config config.yaml
    ```

    **Neste exemplo, definimos um cluster com um `control-plane` e dois `workers`**

Você deve conseguir ver os nós do cluster em execução com o comando: `docker ps`:

!!! tip ""

    ```py
    isntruct@DESKTOP:~/home/kind$ docker ps
    ```

    ```py
    CONTAINER ID   IMAGE                  COMMAND                  CREATED              STATUS              PORTS                       NAMES
    3d5138d41558   kindest/node:v1.27.1   "/usr/local/bin/entr…"   About a minute ago   Up About a minute                               kind-worker
    7ff553f3ee0f   kindest/node:v1.27.1   "/usr/local/bin/entr…"   About a minute ago   Up About a minute                               kind-worker2
    4ccd303f4e07   kindest/node:v1.27.1   "/usr/local/bin/entr…"   About a minute ago   Up About a minute   127.0.0.1:35617->6443/tcp   kind-control-plane
    ```

## Interacting with the Cluster

Depois de criar um cluster, você pode usar `kubectl` para interagir com ele usando o arquivo de configuração gerado por kind.

Por padrão, a configuração de acesso ao cluster é armazenada em ${HOME}/.kube/config se a variável de ambiente `$KUBECONFIG` não estiver definida.

### Kubectl Basic Usage

!!! note ""

    ```sh
    # Verificar a versão do cliente e do servidor Kubernetes
    kubectl version

    # Obter informações sobre os componentes do cluster
    kubectl cluster-info

    # Verificar o status de saúde dos nós do cluster
    kubectl get nodes

    # Obter informações sobre um ou mais recursos
    kubectl get <resouce> -n <namespace>
    kubectl get namespaces -A # -A: get resources on all namespaces

    # Criar um namespace
    kubectl create namespace <namespace>

    # Trocar para um namespace específico
    kubectl config set-context --current --namespace=<namespace>

    # Listar os serviços disponíveis
    kubectl get services

    # Listar os deployments disponíveis
    kubectl get deployments

    #View cluster events:
    kubectl get events

    # Exibir eventos relacionados a um recurso
    kubectl describe events

    #View the kubectl configuration:
    kubectl config view
    
    # Verificar a utilização de recursos (CPU, memória) por um Pod
    kubectl top pod my-pod

    # Obter informações sobre um pod em formato YAML/JSON
    kubectl get pod <pod> -o yaml/json

    # Criar um novo recurso
    kubectl create <resource> <-optins>
    kubectl create deployment my-deployment --image=my-image:tag --replicas=2

    # Redimensionar o número de réplicas de um conjunto de réplicas (Deployment)
    kubectl scale deployment/<deployment-name> --replicas=3

    # Apagar um ou mais recursos
    kubectl delete <resouce> <resource-name>
    kubectl delete pod my-pod

    # Exibir detalhes de um recurso específico
    kubectl describe <resource> -n <namespace>
    kubectl describe pod my-pod -n <namespace>

    # Executar um comando em um contêiner de um Pod
    kubectl exec <pod-name> -n <namespace> -- <command>
    kubectl exec my-pod -n <namespace> -- ls /app

    # Executar um comando específico em todos os Pods de um conjunto de réplicas
    kubectl exec deployment/<deployment-name> -- ls /app

    # Criar um Pod temporário para executar um comando de depuração
    kubectl debug my-pod --image=debug-image:latest

    # Acompanhar os logs de um Pod
    kubectl logs <pod-name> 

    # Acessar a linha de comando de um contêiner em execução em um Pod
    kubectl attach <pod-name> -c <container-name>
    kubectl attach my-pod -c <container-name>

    # Expor um serviço para acesso externo
    kubectl expose deployment <deployment-name> --port=<port>
    kubectl expose deployment my-deployment --port=8080

    # Criar um encaminhamento de porta para acessar um Pod
    kubectl port-forward <pod-name> <container-port>:<host-port>
    kubectl port-forward my-pod 8080:80

    # Criar um secret a partir de um arquivo ou valor
    kubectl create secret <type> <secret-name> --from-file=<secret-file>.txt
    kubectl create secret generic my-secret --from-file=my-secret-file.txt

    # Criar um ingress para rotear o tráfego externo para um serviço
    kubectl create ingress my-ingress --rule=host=my-domain.com

    # Criar um Job para executar uma tarefa em lote
    kubectl create job my-job --image=my-image:tag

    # Criar um cronjob para executar tarefas em intervalos regulares
    kubectl create cronjob my-cronjob --schedule="0 0 * * *"

    # Criar um PersistentVolume e PersistentVolumeClaim
    kubectl create persistentvolume my-pv --size=1Gi

    # Criar um ConfigMap a partir de um arquivo de configuração
    kubectl create configmap my-configmap --from-file=my-config.txt

    # Atualizar a configuração de um recurso
    kubectl edit deployment/<deployment-name>

    # Atualizar a imagem de um Pod em execução
    kubectl set image pod/my-pod my-container=my-image:tag

    # Visualizar o estado de um rollout (deployment, replicaset, etc.)
    kubectl rollout status deployment/<deployment-name>
    ```

> Note: Para mais informações sobre o utilitário `kubectl`, veja: [kubectl overview](https://kubernetes.io/docs/reference/kubectl/).

### Deploying a kubernetes Dashboard UI

!!! tip ""

    O kubernetes não possui uma interface grafica, mas podemos instalar uma com os seguintes comandos:

    ```yaml
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

    # Via helm:
    helm install dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard --create-namespace
    ```

    Tenha acesso a Dashboard do Kubernetes executando:

    ```sh
    export POD_NAME=$(kubectl get pods -n kubernetes-dashboard -l "app.kubernetes.io/name=kubernetes-dashboard,app.kubernetes.io/instance=dashboard" -o jsonpath="{.items[0].metadata.name}")
    echo https://127.0.0.1:8443/
    kubectl -n kubernetes-dashboard port-forward $POD_NAME 8443:8443
    ```

    ***Agora você apenas precisa acessar: [https://localhost:8443](https://localhost:8443/#/login)***

A dashboard tambem pode ser acessada via `proxy`:

!!! tip "Isso fará o proxy dos endpoints do cluster do Kubernetes para o host, para que possamos acessá-los"

    ```sh
    kubectl proxy
    ```

    E então sua dashboard estará disponivel neste endereço: [http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:dashboard-kubernetes-dashboard:https/proxy/#/login](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:dashboard-kubernetes-dashboard:https/proxy/#/login)

### Accessing the Dashboard UI

Precisamos criar um usuário e anexar a permissão necessária para acessar a dashboard

***Criando um usuário***

!!! danger "Conceder privilégios de administrador à `service-account` da Dashboard pode ser um risco de segurança"

***Criando uma Service Accout***
!!! note "service-account.yaml"
    - Isso criará uma `service-account` com o nome `admin-user` no namespace `kubernetes-dashboard`:

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: admin-user
      namespace: kubernetes-dashboard
    ```

***Criando uma ClusterRoleBinding***
!!! note "cluster-role-binding.yaml"

  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: admin-user
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: admin-user
    namespace: kubernetes-dashboard
  ```

***Execute um Apply nos manifestos***

```sh
kubectl apply -f service-account.yaml -f cluster-role-binding.yaml
```

***Crie um Bearer Token***

Para obter o token que podemos usar para fazer login, execute o seguinte comando:

```yaml
kubectl -n kubernetes-dashboard create token admin-user
```

### ***Configuração de Pod e Deployments***

***pods***

Use o comando `kubectl create` para criar um pod. O pod executa um contêiner com base na imagem fornecida.

Via kubectl:

```sh
kubectl run my-pod --image=my-image:tag --port=8080
```

Usando um arquivo YAML:

- Crie um arquivo YAML chamado `pod.yaml` com o seguinte conteúdo:

!!! note "pod.yaml"
    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
    name: my-pod
    spec:
    containers:
        - name: my-container
        image: my-image:tag
        ports:
            - containerPort: 8080
    ```

    Em seguida, aplique o arquivo YAML usando o seguinte comando:

    ```sh
    kubectl apply -f pod.yaml
    ```

Veja the Pod:

```sh
kubectl get pods <pod-name> -n <namespace>
```

A saída do comando deve ser similar:

```yaml
NAME                      READY   STATUS    RESTARTS      AGE
my-pod-h5qcc              1/1     Running   0             24m
cloud-native-9rbfn        1/1     Running   0             24m
...
```

***Deployment***

Use o comando kubectl create para criar um `Deployment` que gerencia um `pod`. O `pod` executa um contêiner com base na imagem fornecida.

```sh
# Run a test container image that includes a webserver
kubectl create deployment hello-node --image=registry.k8s.io/e2e-test-images/agnhost:2.39 -- /agnhost netexec --http-port=8080
```

Para realizar o deployment via yaml:

!!! note "deployment.yaml"

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
            image: nginx:1.14.2
            ports:
            - containerPort: 80
    ```

    apply that deployment manifest on cluster running:

    ```yaml
    kubectl apply -f deployment.yaml
    ```

    - Isso criará um `Deployment` e um `ReplicaSet` no namespace `default`, para subir 3 pods de nginx

Veja o Deployment:

```sh
kubectl get deployments hello-node -n <namespace>
```

A saida do comando deve ser similar:

```yaml
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   3/3     3            3           1m
```

### ***Criação de ConfigMaps e Secrets***

Crie e configure um ConfigMap e Secrets usando kubectl e YAML

***ConfigMap***

via Kubectl:

```sh
kubectl create configmap <configmap-name> --from-literal=key1=value1 --from-literal=key2=value2
```

via yaml:

- Crie um arquivo yaml chamado `configmap.yaml` com o seguinte conteúdo:

!!! note "configmap.yaml"

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: <configmap-name>
    data:
      key1: value1
      key2: value2
    ```

    Then apply the YAML manifest:

    ```sh
    kubectl apply -f configmap.yaml
    ```

Veja os ConfigMaps:

```sh
kubectl get configmap <configmap-name> -n <namespace>
```

A saida do comando deve ser similar:

```yaml
NAME                            DATA   AGE
<configmap-name>                0      3h15m
```

<hr>

***Secrets***

Via Kubectl:

```sh
kubectl create secret generic <secret-name> --from-literal=key1=value1 --from-literal=key2=value2
```

Via YAML:

- Crie um arquivo yaml chamado `secrets.yaml` com o seguinte conteúdo:

!!! note "secrets.yaml"

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: <secret-name>
    type: Opaque
    data:
      key1: dmFsdWUx    # Base64 encoded value1
      key2: dmFsdWUy    # Base64 encoded value2
    ```

    Certifique-se de codificar os valores no formato `Base64` antes de adicioná-los ao arquivo YAML.

    ```sh
    kubectl apply -f secret.yaml
    ```

Veja as secrets:

```sh
kubectl get secret -A
```

A saida deve ser semelhante:

```yaml
NAME                                   TYPE                 DATA   AGE
<secret-name>                          Opaque               2      2h12m
dashboard-kubernetes-dashboard-certs   Opaque               0      3h16m
kubernetes-dashboard-csrf              Opaque               1      3h16m
kubernetes-dashboard-key-holder        Opaque               2      3h16m
sh.helm.release.v1.dashboard.v1        helm.sh/release.v1   1      3h16m
...
```

### ***Configuração de Services e Ingress***

Crie e configure um `service` e um `ingress` usando kubectl e YAML:

***Services***

***Tipos disponiveis***

Os tipos de serviço do Kubernetes permitem que você especifique o tipo de serviço que deseja.

!!! note ""
    ***ClusterIP***

    - Expõe o serviço em um IP interno do cluster;
    - Esse tipo torna o serviço acessível apenas de dentro do cluster;
    - Esse é o tipo padrão de service utilizado se nenhum valor for definido;

    ***NodePort***

    - Expõe o serviço no IP de cada nó em uma porta estática (o NodePort).

    ***LoadBalancer***

    - Expõe o serviço externamente usando um load-balancer externo;

    ***ExternalName***

    - Permite expor um serviço externo através de um DNS personalizado;

Via kubectl:

```sh
kubectl expose deployment <deployment> -n <namespace> --type=<service-type> --port=80 --target-port=8080
```

Via YAML:

- Crie um arquivo YAML chamado <service.yaml> com o seguinte conteúdo:

!!! note "service.yaml"
    
    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: <service-name>
    spec:
      selector:
        <selector-label>: <selector-value>
    ports:
    - protocol: <protocol>
        port: <port>
        targetPort: <target-port>
    ```

    Then apply the YAML manifest:

    ```sh
    kubectl apply -f service.yaml
    ```

Veja os Services:

```sh
kubectl get service <service-name>
```

A saida deve ser semelhante:

```yaml
NAME                    TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
<service-name>          ClusterIP   10.96.143.1   <none>        443/TCP   3h18m
```

<hr>

***Ingress***

Via kubectl:

```sh
kubectl create ingress <ingress-name> --rule=<rule-pattern>
```

Via YAML:

- Crie um arquivo YAML chamado `ingress.yaml` com o seguinte conteúdo:

!!! note "ingress.yaml"
    
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: <ingress-name>
    spec:
      rules:
      - host: <host-pattern>
        http:
        paths:
        - pathType: Prefix
            path: /
            backend:
              service:
                name: <backend-service>
                port:
                  number: <backend-service-port>
    ```

    Then apply the YAML manifest:

    ```sh
    kubectl apply -f ingress.yaml
    ```

Vejá o Ingress:

```sh
kubectl get ingress
```

A saida deve ser semelhante:

```yaml
NAME           CLASS    HOSTS                          ADDRESS   PORTS   AGE
cloud-native   <none>   instruct.cloud-native.com.br             80      7s
```

### ***Configuração de um Volume***

Via kubectl:

```sh
kubectl create -f <volume-manifest.yaml>
```

Via YAML:

- Crie um arquivo YAML chamado `volume-manifest.yaml` com o seguinte conteúdo:

!!! note "volume.yaml"

    ```yaml
    apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: <volume-name>
    spec:
      capacity:
        storage: <storage-size>
      accessModes:
        - <access-mode>
      hostPath:
        path: <host-path>
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: <pvc-name>
    spec:
      accessModes:
        - <access-mode>
      resources:
        requests:
        storage: <storage-size>
      volumeName: <volume-name>
    ```

    Then apply the YAML manifest:

    ```sh
    kubectl apply -f volume.yaml
    ```

Veja os `Persistence Volume Clain`:

```sh
kubectl get pvc
```

A saida deve ser semelhante:

```yaml
NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                             STORAGECLASS   REASON   AGE
pvc-043ed9c1-...   8Gi        RWO            Delete           Bound    default/data-grafana-loki-1686599256-querier-0    standard                15m
pvc-188f0d07-...   8Gi        RWO            Delete           Bound    default/grafana-loki-1686599438-compactor         standard                12m
```

Veja os `Persistence Volume`:

```sh
kubectl get pv
```

A saida deve ser semelhante:

```yaml
luke@DESKTOP-7A3AHF1:~/luke/kind$ kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-689256-0   Bound    pvc-6a2c5557-21b3-46a1-abee-b79c79bcabd8   8Gi        RWO            standard       15m
data-18656-0    Bound    pvc-043ed9c1-8441-4e1c-9fbb-49c4f58b3140   8Gi        RWO            standard       15m
```

## Destruindo um Cluster

Se você criou um cluster com kind create cluster, a exclusão é igualmente simples:

```sh
kind delete cluster
```
