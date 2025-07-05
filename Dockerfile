FROM ruby:3.3

# Node e Yarn para assets
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update -qq && apt-get install -y nodejs yarn build-essential libpq-dev

# Cria diretório da aplicação
WORKDIR /app

# Copia os arquivos
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Prepara entrypoint
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Porta padrão
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
