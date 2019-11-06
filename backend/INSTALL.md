# Processos para implatanção da aplicação

Executar os comandos abaixo no terminal:

```sh
docker-compose build

docker-compose run --rm app bundle exec rake db:create db:migrate

docker-compose up -d
```
