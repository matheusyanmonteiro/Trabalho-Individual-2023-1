# Define a imagem base
FROM ruby:3.0.4

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia todos os arquivos do projeto para o diretório de trabalho
COPY . .

# Define as variáveis de ambiente
ENV RAILS_ENV=development
ENV RAILS_SERVE_STATIC_FILES=true
ENV DATABASE_HOST=postgres
ENV DATABASE_USERNAME=postgres
ENV DATABASE_PASSWORD=postgres

# Instala as dependências do projeto
RUN gem install bundler && \
    bundle config set without 'production' && \
    bundle install --jobs 20 --retry 5

# Instala as dependências do Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Instala o Yarn
RUN npm install -g yarn

# Instala as dependências do projeto JavaScript
RUN yarn install --check-files

# Instala a gem Mailcatcher
RUN gem install mailcatcher --no-document

# Cria e migra o banco de dados
RUN bundle exec rails db:create && \
    bundle exec rails db:migrate


# Define o comando a ser executado quando o container for iniciado
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]