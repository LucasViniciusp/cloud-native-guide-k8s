# Helm

Helm é um gerenciador de pacotes popular para Kubernetes que ajuda você a empacotar, implantar e gerenciar aplicativos.

## :material-kubernetes: Helm Installation

!!! note ""
    ```sh
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    ```

## Using Helm Charts

!!! warning "Requirements"
    - [Kind Cluster](kubernetes.md) Running

Disponibilizando um repositório de charts:

!!! note ""
    ```sh
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update

    # List of available charts:
    helm search repo bitnami

    # Show Chart details:
    helm show chart bitnami/mysql
    ```

Depois de instalado, você poderá listar os charts que pode instalar:

!!! note ""
    ```sh
    helm search repo bitnami
    ```

    ```
    NAME                        CHART VERSION	APP VERSION  	DESCRIPTION
    bitnami/bitnami-common      0.0.9        	0.0.9        	DEPRECATED Chart with custom ...
    bitnami/airflow             8.0.2        	2.0.0        	Apache Airflow is a platform ...
    bitnami/apache              8.2.3        	2.4.46       	Chart for Apache HTTP Server
    bitnami/aspnet-core         1.2.3        	3.1.9        	ASP.NET Core is a framework ...
    # ... and many more
    ```

### Deploying a chart

!!! note ""

    instalando um chart do repositório da `bitnami`:
    ```sh
    helm install bitnami/mysql --generate-name
    ```

    ```
    NAME: mysql-1612624192
    LAST DEPLOYED: Sat Feb  6 16:09:56 2021
    NAMESPACE: default
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES: ...
    ```

!!! note ""
    Removendo o chart instalando anteriormente:
    ```sh
    helm uninstall mysql-1617481683
    ```

## Helm basic usage

!!! tip "Check [Helm commands](https://helm.sh/docs/helm/) oficial documentation"

!!! note ""
    ```sh
    # Cria um novo Chart
    helm create <chart-name>

    # Instala um pacote em um cluster Kubernetes.
    helm install <chart-name> ./<chart-folder>

    # Atualiza um pacote que já está instalado.
    helm upgrade <chart-name> ./<chart-folder>

    # Desinstala um pacote de um cluster Kubernetes.
    helm uninstall <chart-name>

    # Lista todos os pacotes instalados em um cluster Kubernetes.
    helm list

    # Mostra o status de um pacote instalado em um cluster Kubernetes.
    helm status <chart-name>

    # Mostra informações detalhadas sobre um pacote do Helm.
    helm show chart ./<chart-folder>

    # Adiciona um repositório de Helm charts.
    helm repo add stable https://charts.helm.sh/stable

    # Atualiza os repositórios do Helm.
    helm repo update

    # Pesquisa por pacotes disponíveis em repositórios.
    helm search repo

    # Verifica a validade de um pacote do Helm.
    helm lint ./<chart-folder>

    # Empacota um diretório em um arquivo .tgz.
    helm package ./<chart-folder>

    # Instala um plugin do Helm.
    helm plugin add https://github.com/databus23/helm-diff

    # Lista todos os plugins instalados.
    helm plugin list

    # Atualiza um plugin do Helm.
    helm plugin update diff
    ```

## Empacotando sua aplicação usando Helm


Para empacotar sua aplicação, você só precisa navegar até o diretório raiz do sua aplicação e criar um Chart Helm executando o comando `helm create`

!!! note "*Isso criará uma nova estrutura de diretório que contém modelos, valores e outros arquivos de configuração.*"
    ```sh
    cloud-native/
    ├── Chart.yaml
    ├── charts
    ├── templates
    │   ├── NOTES.txt
    │   ├── _helpers.tpl
    │   ├── deployment.yaml
    │   ├── hpa.yaml
    │   ├── ingress.yaml
    │   ├── service.yaml
    │   ├── serviceaccount.yaml
    │   └── tests
    │       └── test-connection.yaml
    └── values.yaml
    ```

    Agora basta modificar os arquivos gerados no diretório do Chart:

    - Modifique o arquivo `Chart.yaml` para fornecer metadados sobre seu Chart

    - Personalize o arquivo `values.yaml` para definir variáveis ​​e valores padrão para sua aplicação.

    - Personalize os manifestos do Kubernetes do sua aplicação no diretório `templates/`

!!! note ""

    - O `values.yaml` contém os valores padrão para um Chart. Esses valores podem ser substituídos pelos usuários durante a instalação do helm ou atualização do helm fazendo alterações no arquivo ou usando a opção `--set` para sobrescrever valores (geralmente senhas e dados sensíveis).

    - O diretório `templates/` contém os arquivos de modelo que serão processados ​​para gerar os manifestos finais do Kubernetes para implantação.

    - O arquivo `Chart.yaml` contém os metadados do Chart.

    - O diretório `charts/` pode conter subcharts

Depois de empacotar sua aplicação como um Chart Helm, você pode implantá-lo em um cluster Kubernetes:

### Install the Helm chart using the following command

!!! note ""
    ```sh

    # release-name: name for the release
    # chart-name: name of the chart

    helm install <release-name> <chart-name>
    ```

    Personalize a instalação fornecendo `values.yaml` ou usando o sinalizador `--set` para substituir valores específicos:

    ```sh
    helm install <release-name> <chart-name> --values values.yaml --set database.password=$DB_PASS
    ```

!!! tip "use `--set` to specify values directly on the command line."

### Updating and Uninstalling

!!! note ""
    ```sh
    #  To update a release, run:
    helm upgrade <release-name> <chart-name>

    # To uninstall a release, run:
    helm uninstall <release-name>
    ```

!!! tip "Instale ou atualize uma release com um comando"
    Use `helm upgrade` com o parâmetro `--install`. Isso fará com que o Helm verifique se a release já está instalada para atualização. Caso contrário, ele executará uma instalação.

    ```sh
    helm upgrade --install <release> --values <values file> <chart directory> --set <key.parameter>=<value>
    ```

## Values Files

Um dos objetos built-in em um template helm é o `Values`. Este objeto fornece acesso aos valores passados ​​para o Chart.

- Um arquivo com values é passado para a instalação ou atualização do helm com o sinalizador -f `#!sh helm install -f myvals.yaml ./mychart`

- Parâmetros individuais podem ser passados ​​com `--set`
    ```sh
    helm install --set foo=bar ./mychart
    ```

Os arquivos de valores são arquivos YAML simples. Vamos editar `mychart/values.yaml` e depois editar nosso template de ConfigMap removendo os valores padrões em `values.yaml`, vamos definir apenas um parâmetro:

```yaml
favoriteDrink: coffee
```

Now we can use this inside of a template:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Release.Name }}-configmap
data:
  myvalue: "Hello World"
  drink: {{ .Values.favoriteDrink }}
```

Notice on the last line we access favoriteDrink as an attribute of Values

How this renders:
!!! note ""

    ```sh
    helm install geared-marsupi ./mychart --dry-run --debug
    ```

    ```yaml
    install.go:158: [debug] Original chart version: ""
    install.go:175: [debug] CHART PATH: /home/bagratte/src/playground/mychart
    ```

    ```yaml
    NAME: geared-marsupi
    LAST DEPLOYED: Wed Feb 19 23:21:13 2020
    NAMESPACE: default
    STATUS: pending-install
    REVISION: 1
    TEST SUITE: None
    USER-SUPPLIED VALUES:
    {}

    COMPUTED VALUES:
    favoriteDrink: coffee

    HOOKS:
    MANIFEST:
    ---
    # Source: mychart/templates/configmap.yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: geared-marsupi-configmap
    data:
      myvalue: "Hello World"
      drink: coffee
    ```


Como `favoriteDrink` é definido no arquivo `values.yaml` como `coffee`, esse é o valor exibido no template.

- Podemos substituir isso facilmente adicionando um parametro `--set` em nossa chamada para a instalação do helm:
!!! note ""
    ```sh
    helm install solid-vulture ./mychart --dry-run --debug --set favoriteDrink=slurm
    ```

    ```yaml
    install.go:158: [debug] Original chart version: ""
    install.go:175: [debug] CHART PATH: /home/bagratte/src/playground/mychart
    ```

    ```yaml
    NAME: solid-vulture
    LAST DEPLOYED: Wed Feb 19 23:25:54 2020
    NAMESPACE: default
    STATUS: pending-install
    REVISION: 1
    TEST SUITE: None
    USER-SUPPLIED VALUES:
    favoriteDrink: slurm

    COMPUTED VALUES:
    favoriteDrink: slurm

    HOOKS:
    MANIFEST:
    ---
    # Source: mychart/templates/configmap.yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: solid-vulture-configmap
    data:
      myvalue: "Hello World"
      drink: slurm
    ```


Já que `--set` tem precedência maior que o arquivo `values.yaml` padrão, nosso modelo gera `drink: slurm`.

Os arquivos de valores também podem conter conteúdo mais estruturado. Por exemplo:

!!! note ""
    
    - poderíamos criar uma seção favorita em nosso arquivo `values.yaml` e adicionar nossas chaves lá:

        ```yaml
        favorite:
          drink: coffee
          food: pizza
        ```

    - Agora teríamos que modificar um pouco o template:
    
        ```yaml
        apiVersion: v1
        kind: ConfigMap
        metadata:
          name: {{ .Release.Name }}-configmap
        data:
          myvalue: "Hello World"
          drink: {{ .Values.favorite.drink }}
          food: {{ .Values.favorite.food }}
        ```

### Deleting a default key

Se precisar excluir uma chave definida no `values`, você pode ***substituir o valor da chave para nulo***, nesse caso o Helm irá removerá a chave.

!!! exemplo "Exemplo: o Chart `Drupal` estável permite configurar um liveness probe"

    Aqui estão os valores padrão:

    ```yaml
    livenessProbe:
      httpGet:
        path: /user/login
        port: http
      initialDelaySeconds: 120
    ```

    Se você tentar substituir o handler usado no `livenessProbe` para exec em vez de `httpGet` usando:

    ```yaml
    --set livenessProbe.exec.command=[cat,docroot/CHANGELOG.txt]
    ```

    O Helm unirá as chaves, resultando no seguinte YAML:

    ```yaml
    livenessProbe:
      httpGet:
        path: /user/login
        port: http
      exec:
        command:
        - cat
        - docroot/CHANGELOG.txt
      initialDelaySeconds: 120
    ```

    No entanto, deployment falharia porque você não pode declarar mais de um handler para o `livenessProbe`. Para superar isso, você pode instruir o Helm a excluir `#!yaml livenessProbe.httpGet` definindo-o como `null`:

    ```yaml
    helm install stable/drupal --set image=my-registry/drupal:0.1.0 --set livenessProbe.httpGet=null --set livenessProbe.exec.command=[cat,docroot/CHANGELOG.txt]
    ```
