# Desafio

## Objetivo

***Implantar uma aplicação web em um cluster Kubernetes (KIND) usando o Docker e o Helm.***

### Passos

### 1. Subir um banco de dados PostgreSQL

- O banco deve possuir um volume para persistência dos dados.

```sh
docker run --name postgres -e POSTGRES_PASSWORD=postgres -v ~/pgdata:/var/lib/postgresql/data -p 5432:5432 -d postgres
```

### 2. Conectar uma aplicação ao banco de dados

- Apos subir o banco Postgres, tente conectar o projeto `django` que está no diretório `desafio` deste projeto.

### 3. Containerize a aplicação

- Containerize sua aplicação Django criando um `Dockerfile`.

### 4. Crie um `docker-compose`

- Crie um `docker-compose` com o `service` da aplicação e do banco de dados;
- Certifique-se de adicionar a dependência do banco no service da aplicação;
- Confirme que sua aplicação consegue acessar o banco de dados;
- Remova as variáveis de ambiente sensíveis do código.

### 5. Crie um cluster Kubernetes

- Configure um cluster Kubernetes local usando `Kind` com no mínimo 3 nodes;
- Certifique-se de que o cluster esteja pronto para receber implantações.

### 6. Realize a instalação do `Kubernetes Dashboard` no seu cluster

- Você também precisará criar uma `service-account` e um `cluster-role-binding`;
- Crie um token de acesso para a dashboard.

### 7.  Empacote sua aplicação utilizando Helm

- Crie um Chart Helm para o deploy da sua aplicação, e configure os valores padrão no arquivo `values.yaml`;
- Lembre de manter o `pod` do banco de dados separado do pod da aplicação;
- utilize o parâmetro `--set` ao instalar o chart helm para sobrescrever variáveis sensíveis do arquivo `values.yaml`;
- Persista suas variáveis através de `secrets` e `configMaps`;
- Crie services para sua aplicação e banco;
- Crie um namespace para a sua aplicação

### 8. Teste sua aplicação usando Helm

- Faça uma pequena alteração na sua aplicação e faça update na implantação usando o Helm
- Faça alguns testes utilizando a estratégia de deployment `Recreate` e `RollingUpdate`

### 9. Teste a escalabilidade

- Adicione escalabilidade horizontal criando novas replicas e um `(HPA)` para sua implantação
- Adicione escalabilidade vertical definindo valores de `request` e `limite` para os `resources` da sua implantação

!!! info "[(HPA) - Horizontal Pod autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)"

### 10. Execute um Registry localmente

- Crie um registry local utilizando Harbor ou `Distribution`
- Suba suas imagens para este registry e utilize-as no helm
