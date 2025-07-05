#!/bin/bash
set -e

# Espera o banco estar disponível
if [ "$RAILS_ENV" = "development" ]; then
  echo "Aguardando o banco de dados..."
  ./bin/wait-for-it.sh db:5432 --timeout=30 -- echo "Banco disponível!"
fi

# Executa migrations apenas
bundle exec rails db:migrate

exec "$@"
