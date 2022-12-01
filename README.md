## Installing

### Install Script

To install, you should run the install script.

```sh
sh -c "$(curl -o- https://raw.githubusercontent.com/dan-versiane-org/projects-development-manager/main/tools/install.sh)"
```
### - Dentro da pasta .pdm cria uma pasta plugins
#
### - Editando .zsh
````
## Loads PDM
export PDM_DIR="${HOME}/.pdm"
[[ -f "${PDM_DIR}/pdm.sh" ]] && \. "${PDM_DIR}/pdm.sh"
````
### - Clona os repositorios dentro da pasta plugins
````
git@github.com:dan-versiane-org/pdm-plugin-git.git git
`````
`````
git@github.com:dan-versiane-org/pdm-plugin-dump.git dump
``````
``````
git@github.com:dan-versiane-org/pdm-plugin-docker.git docker
``````

### - Criando Workspace

```
pdm workspace create orbits
```

### Setando o Workspace padrão

```
pdm workspace set orbbits
````

````
cd orbbits
`````
`````
git init && git remote add origin git@github.com:Big-Bang-Digital/orbbits-workspace.git && git fetch && git checkout main
`````
### Comandos pdm git

````
pdm git help
  checkout  Switch to a different branch of projects.
  clone     Clone a git repo.
  current   Show the current branch of projects.
  help      Show plugin help.
  version   Show plugin version.
````
### Clonando Projeto
dentro da pasta orbbits, execute o comando:
````
pdm git clone
````
### Restaurar Backup .evn, que está no caminho orbbits/backup

`````
pdm dump restore {nome-backup}
``````

### Alterar o host, acrescentando os novos 
Linux: (/etc/hosts)
Windows: (c:\windows\system32\drivers\etc\hosts)

  `````
## Exposto
127.0.0.1       abertura.orbbits.local
127.0.0.1       apiapp.orbbits.local
127.0.0.1       boleto.orbbits.local
127.0.0.1       orbbits.local
127.0.0.1       external.orbbits.local
127.0.0.1       gateway.orbbits.local
127.0.0.1       identity.orbbits.local
127.0.0.1       status.orbbits.local
## Front
127.0.0.1       cart.app
127.0.0.1       client.app
127.0.0.1       consultant.app
127.0.0.1       lp-minaspetro.app
127.0.0.1       orbbits.app
## Services Local
127.0.0.1       backoffice-service.local
127.0.0.1       charges-service.local
127.0.0.1       clients-service.local
127.0.0.1       consultants-service.local
127.0.0.1       crivo-service.local
127.0.0.1       dl-service.local
127.0.0.1       leads-service.local
127.0.0.1       marketing-service.local
127.0.0.1       messages-service.local
127.0.0.1       newcon-service.local
127.0.0.1       partner-service.local
127.0.0.1       partner-service-2.local
127.0.0.1       quotas-service.local
127.0.0.1       report-service.local
127.0.0.1       scheduler-service.local
127.0.0.1       storage-service.local
127.0.0.1       telemetry-service.local
127.0.0.1       users-service.local
``````
### Build nos projetos
`````
pdm docker build
`````

### Docker subindo Container sem startar os serviços

`````
pdm docker up -d --no-start
``````
