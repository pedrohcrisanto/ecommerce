
# Teste Engenheiro de Software Pleno

## Configuração

Build e inicie o Docker Compose
```sh
$ sudo docker compose up --build
```

Inicie o sidekiq
```sh
$ sudo docker compose exec web bundle exec sidekiq
```

Rode o Seed de Produtos
```sh
$ sudo docker compose exec web rails db:seed
```
Crie o banco e migre as tabelas se necessario.
## Documentação Swagger
[http://localhost:3000/api-docs](http://localhost:3000/api-docs)

```
Id's mockados de Product disponiveis no Seed para uso na interface do Swagger
[ 123, 345, 678, 1230, 528 ]
```
## Sidekiq Cron
[http://localhost:3000/sidekiq/cron](http://localhost:3000/sidekiq/cron)

## Cobertura de Testes
```sh
$ sudo docker compose exec web rspec
```
## Dependencias
Docker e Docker Compose
