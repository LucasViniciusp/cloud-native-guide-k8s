# Docker

Usando o Docker, podemos criar de forma consistente e automática ambientes isolados e portáteis para aplicações.

## 🐳 **Install Docker**

O Docker fornece um script pratico em [get.docker.com](https://get.docker.com) para instalar o Docker.

!!! warning "Esse script não é recomendado para ambientes produtivos"
    ```sh
    sudo -i
    curl -fsSL https://get.docker.com | bash

    systemctl enable docker
    systemctl restart docker

    docker ps
    ```

### **Root privileges**

Por padrão, o daemon do Docker faz bind em um socket Unix, e não em uma porta TCP. Sockets Unix, por sua vez, são de propriedade e de uso exclusivo do usuário root (por isso o Docker sempre é iniciado como root).

Para evitar o uso contínuo do comando sudo ao rodar comandos Docker, utilize o grupo docker que é criado durante a instalação e adicione o seu usuário a ele.

Esse procedimento permite que o usuário tenha os mesmos privilégios do usuário root em operações relacionadas ao Docker.

Mais informações: [https://docs.docker.com/engine/security/](https://docs.docker.com/engine/security/).

Para criar um grupo no Linux e adicionar um usuário:

    sudo usermod -aG docker $(whoami)

## **Interagindo com o container**

O docker é acessado via terminal através do comando `docker`.

### Hello World

O Docker disponibiliza uma imagem personalizada chamada "hello-world", que serve para testar a instalação e validar se tudo está funcionando conforme o esperado.

Para executar um contêiner, utilizamos o parâmetro `run` do comando `docker`.

!!! example "Exemplos:"
    ```sh
    # Execute um container hello-world:
    docker container run hello-world

    # Execute um container com Ubuntu:
    docker run -it ubuntu bash
    ```

!!! tip "Docker `RUN` common parameters"

    - Utilizando o parâmetro `-d` faz com que o container seja executado em background.
    - `-p`: Publica/expõe a(s) porta(s) de um contêiner para o host.
    - `-e`: Define variáveis de ambiente.
    - `-it`: cria uma sessão que permite a interação em tempo real com o contêiner.
        - `-i`: permite que você mantenha a entrada padrão (stdin) aberta para interagir com o contêiner em tempo real.
        - `-t`: aloca um pseudo-terminal para o contêiner, permitindo que você visualize a saída do contêiner de forma formatada.

!!! note "Fluxo de criação e execução de um container:"

    1. O cliente do Docker se comunica com o daemon do Docker.
    2. O daemon do Docker baixa a imagem do registro caso ela não exista no host.
    3. O daemon do Docker cria e executa um novo contêiner a partir da imagem definida.

### Basic usage

!!! tip ""

    ```sh
    # Executa um container CentOS 7 e cria uma sessão iterativa
    docker run -it centos:7 # (1)

    # Lista os containers em execução
    docker ps # (2)

    # Pausa os containers em execução
    docker pause <container-id/container-name>

    # Interrompe um container
    docker stop <container-id/container-name>

    # Interrompe todos os containers
    docker stop $(docker ps -qa)

    # Inicia um container
    docker start <container-id/container-name>

    # Reinicia um container
    docker restart <container-id/container-name>

    # Visualizar o uso de recursos dos containers
    docker stats

    # Visualizar os logs de um container
    docker logs <container-id/container-name>

    # Inspecionar toda a configuração de um container # (3)
    docker inspect <container-id/container-name>

    # Delete/Remove um container parado
    docker rm <container-id/container-name> # (4)

    # Atualizar o valor limite de uso dos recursos do contêiner
    docker update -m 256m --cpus=1 <container-id/container-name> # (5)
    ```

    1. Você pode usar qualquer outra imagem disponível no Docker Hub ou no seu registro privado.
    2. Use a opção -a/-all para listar até mesmo os contêineres parados.
    3. O comando "inspect" é extremamente útil para depuração.
    4. Quando um contêiner é excluído, a imagem permanece no host.
    5. Por padrão, o contêiner não tem limite de recursos. <br>
       Use docker update --help para verificar as opções disponíveis. <br>
       Isso funciona mesmo para contêineres em execução.

## Dockerfile

O `Dockerfile` é um arquivo de configuração usado para definir e construir imagens de contêineres Docker. Nele, você pode especificar a imagem base, as dependências, as variáveis de ambiente e os comandos necessários para construir uma imagem de contêiner Docker para o seu projeto.

### Getting started

!!! note "Para iniciar, você apenas precisa criar o arquivo: `Dockerfile`"
    `#!docker Dockerfile`

    ```sh
    mkdir /home/cloud-native/
    cd /home/cloud-native/
    touch Dockerfile
    ```

!!! note "Edite seu arquivo com as seguintes instruções:"
    ```sh
    nano Dockerfile
    ```

    ```docker
    FROM nginx

    RUN /bin/echo "HELLO FROM INSTRUCT CLOUD-NATIVE!!!" > /usr/share/nginx/html/index.html

    CMD ["nginx", "-g", "daemon off;"]
    ```

Execute o comando `docker build` para criar uma imagem usando o `Dockerfile`.

!!! tip ""
    ```sh
    docker build -t cloud-native:1.0 .
    ```

    ```docker
    [+] Building 0.7s (6/6) FINISHED
    => [internal] load build definition from Dockerfile                                   0.0s
    => => transferring dockerfile: 37B                                                    0.0s
    => [internal] load .dockerignore                                                      0.0s
    => => transferring context: 2B                                                        0.0s
    => [internal] load metadata for docker.io/library/ubuntu:latest                       0.6s
    => [1/2] FROM docker.io/library/ubuntu@sha256:ac5822fa348fd7....                      0.0s
    => CACHED [2/2] RUN /bin/echo "HELLO FROM INSTRUCT CLOUD-NATIVE"                      0.0s
    => exporting to image                                                                 0.0s
    => => exporting layers                                                                0.0s
    => => writing image sha256:ede41435957b1a79925c3595759b11a6a...                       0.0s
    => => naming to docker.io/library/cloud-native                                        0.0s
    ```

    ```sh
    docker run -d -p 80:80 cloud-native:1.0
    ```

Esse comando irá executar um container utilizando a imagem gerada pelo `Dockerfile` que você criou, e então você poderá ver uma mensagem no seu [localhost](http://localhost)

### Dockerfile ***Instruct***ions

Comando disponíveis na criação de um Dockerfile:

!!! note ""
    ```docker
    FROM:
        - Especifica a imagem base para o Dockerfile.
        - Deve ser a primeira linha do Dockerfile.

    USER:
        - Determina qual usuário será usado na imagem. Por padrão, é o usuário root.

    WORKDIR:
        - Altera o diretório de trabalho dentro do contêiner.
        - O padrão é "/" (raiz).

    COPY:
        - Copia arquivos e diretórios para o sistema de arquivos do contêiner.

    ADD:
        - Copia diretórios e arquivos locais ou remotos para o sistema de arquivos do contêiner.

    ENV:
        - Define variáveis de ambiente para o contêiner.

    VOLUME:
        - Cria um ponto de montagem para armazenar dados persistentes.

    RUN:
        - Executa qualquer comando em uma nova camada em cima da imagem.

    EXPOSE:
        - Informa em qual(is) porta(s) o contêiner irá escutar.

    CMD:
        - Especifica o comando padrão a ser executado quando o contêiner é iniciado.

    ENTRYPOINT:
        - Configura o contêiner para executar um executável específico.
          Quando finalizado, o contêiner também será interrompido.
    ```

## Compartilhando imagens

Até então, estamos utilizando o registry [Docker Hub](https://hub.docker.com/search?q=) para obter as imagens.

Para enviar uma imagem para o Docker Hub:

!!! tip ""
    ***Isso tornará sua imagem disponivel para download para outros usuarios.***

    1. Crie uma conta no [Docker Hub](https://hub.docker.com/signup)
    2. Faça login com usuário e senha executando:
        ```sh
        docker login
        ```
    3. Crie sua imagem usando o `Dockerfile` que você criou anteriormente, utilizando uma tag:
        ```sh
        docker build <your-username>/cloud-native:1.0
        ```
    4. Envie sua imagem para o docker hub registry executando:
        ```sh
        docker push <your-username>/cloud-native:1.0
        ```
    5. E é isso, sua imagem agora está disponível no docker hub!!.

### Criando meu próprio registry

Embora o Docker Hub seja um registry público confiavel, existem casos em que empresas podem optar por não utilizá-lo e preferir um registry interno, como o [Harbor](https://landscape.cncf.io/card-mode?category=container-registry&grouping=category&selected=harbor)!.

Registries internos fornecem um maior controle sobre a segurança, privacidade, conformidade, melhor desempenho e menor latência.

***Criando um registry `Distribution`***
!!! tip ""
    ```sh
    # Crie e execute um registry `Distribution` utilizando docker:
    docker container run -d -p 5000:5000 --restart=always --name registry registry

    # Adicione uma Tag a sua imagem:
    docker tag <image-id> localhost:5000/<tag> # (1)

    # Envie sua imagem para seu registry privado:
    docker push localhost:5000/<tag>
    ```

    1.  Ao buildar uma imagem, o docker gera um `id` que é visível no output do comando!

!!! tip "Outros registries populares:"

    - [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/pt/ecr/)
    - [Azure Container Registry (ACR)](https://azure.microsoft.com/en-us/products/container-registry)
    - [Google Artifact Registry](https://cloud.google.com/artifact-registry?hl=pt-br)
    - [GitLab Container Registry](https://docs.gitlab.com/ee/user/packages/container_registry/)
    - [Harbor](https://landscape.cncf.io/card-mode?category=container-registry&grouping=category&selected=harbor)
    - [Quay](https://landscape.cncf.io/card-mode?category=container-registry&grouping=category&selected=quay)

## Docker-compose

O Docker Compose é uma ferramenta para definir e gerenciar vários contêineres Docker como uma única aplicação, facilitando a configuração, execução e escalabilidade de serviços através de um único arquivo YAML.

### Getting started

Para iniciar, você apenas precisa criar o arquivo: `docker-compose.yaml`

```sh
nano docker-compose.yaml
```

Edite seu arquivo com as seguintes instruções:

!!! note "docker-compose.yaml"

    ```yaml
    version: "3.9"

    services:
      web:
        image: nginx
        ports:
        - "8022:80"
    ```

    para utilizar o docker-compose, execute:
    ```sh
    docker-compose up -d # (1)
    ```

    1.  Se for necessário fazer o build de alguma imagem, você pode adicionar o parâmetro `--build`

Esse `docker-compose` conta com uma configuração minima:

!!! note "Uma `network` é criada por padrão para garantir a conexão entre os containers"

- cria um service chamado `web` utilizando a imagem do `nginx`
- expõe o serviço na porta [`8022`](http://localhost:8022) do host

### Turbinando o docker-compose

***Adicionando um novo service***

Vamos adicionar um postgreSQL ao `docker-compose`:

!!! note ""

    ```yaml
    version: "3"

    services:
      web:
        container_name: nginx-web
        build:
          context: ./Dockerfile
        # target: <stage-name> # (2)
        ports:
        - "8022:80"

      db:
        image: postgres:12.1
        container_name: database
        ports:
        - "5434:5432"
        volumes:
        - ./postgres:/var/lib/postgresql/data # (1)
    ```

    1. `/var/lib/postgresql/data` é o diretório onde os dados ficam armazenados no postgreSQL
    2. adicione um `target` se estiver utilizando multi-stage build

    Alterações:
    ```sh
    - Utiliza o `Dockerfile` do diretório para buildar a imagem
    - Nomeia os containers atraves da chave container_name
    - Adiciona um banco de dados postgreSQL exposto na porta `5432`:
    - Adiciona um volume para persistir os dados do banco # (1)
    ```

    1. Este volume persiste os dados do container postgres na pasta `/postgres` do host.

***Adicionando variáveis de ambiente***

!!! note ""

    ```yaml
    version: "3.9"

    services:
    web:
        container_name: nginx-web
        build:
            context: ./Dockerfile
        # target: <stage-name> (1)
        ports:
        - "8022:80"

    db:
        image: postgres:12.1
        container_name: database
        ports:
        - "5434:5432"
        volumes:
        - ./postgres:/docker-entrypoint-initdb.d
        env_file: .env # (2)
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: cloud-native
    ```

    1. adicione um `target` se estiver utilizando multi-stage build
    2. É nescessario que exista o arquivo `.env`

    - Podemos adicionar variáveis de ambiente no serviço adicionando a chave `environment` e/ou `env_file`

***Adicionando recursos***

!!! note ""

    ```yaml
    version: "3.9"

    services:
    web:
        image: nginx
        ports:
        - "8022:80"

    db:
        image: postgres:12.1
        deploy: # (1)
        resources:
          limits:
            cpus: '0.5'
            memory: '512M'
          reservations:
            cpus: '0.2'
            memory: '256M'
        ports:
        - "5434:5432"
        volumes:
        - ./postgres:/docker-entrypoint-initdb.d
        env_file: .env
        environment:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: cloud-native
    ```

    1. Parâmetros da chave `deploy` funcionam apenas ao utilizar `docker swarm`, exceto pelo `resources`.

    !!! info "Os parâmetros da chave `deploy` funcionam apenas ao utilizar `docker swarm`, valores setados são ignorados pelo `docker-compose up`, exceto pela chave `resources`."

## Boas praticas usando Docker

!!! tip "*Use imagens oficiais e verificadas sempre que possível*"

### Básico

!!! note ""
    - Em vez de usar uma imagem base do sistema operacional e instalar o `node.js`, npm e outras ferramentas necessárias para sua aplicação, utilize a imagem oficial do `node` para sua aplicação.

    - Se você tiver várias imagens com muitos elementos em comum, considere criar a sua própria [base image](https://docs.docker.com/develop/develop-images/baseimages/)
    - Faça uso do arquivo `.dockerignore` para manter apenas os arquivos necessários no container
    - Não utilize a tag `latest` em produção
    - Persista seus dados usando volumes

### Faça uso de Multi-stage build

!!! note ""
    - Você pode ter múltiplas instruções `FROM`no seu Dockerfile, cada uma inicia um novo estagio do build

    - Você poderá seletivamente copiar artefatos de um estagio para outro

    - permitirá você deixar para trás tudo o que você não quiser na imagem final

    - Você pode especificar um `target` para o build executando: `docker build --target <stage>`

    - O parâmetro `target` está disponível no `build` do seu serviço no `docker-compose.yaml`

    ```yaml
    services:
        service_name:
        build:
          image: python:3.9
          target: dev
                ...
    ```

    - *Nomeie os estágios do seu build*

### Evite utilizar imagens do Alpine

Usar Alpine para obter imagens menores é possível, mas vem com alguns desafios:

- Avaliar os compiladores necessários e os cabeçalhos das bibliotecas
- Ter um profundo entendimento da construção de imagens Docker com multi-stage builds

!!! warning "Quando um projeto Python é implantado, **NÃO É RECOMENDADO** usar imagens Alpine como base."

!!! warning "Sem os cabeçalhos das bibliotecas necessárias, o container não vai buildar"

    Sem conhecimento sobre como as camadas e estágios do Docker funcionam, a imagem final pode ser maior do que uma imagem produzida sem Alpine devido a ferramentas de compilação desnecessárias na imagem final.
