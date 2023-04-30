FROM ruby:3.1.2-slim

RUN apt update -q && \
    apt install -qy \
    curl \
    build-essential \
    libpq-dev \
    --no-install-recommends && \
    apt clean

ENV NODE_VERSION=16.15.1
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN npm install yarn --location=global

WORKDIR /code

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install

COPY . .

RUN bundle exec rails assets:precompile

ENTRYPOINT ["bundle", "exec"]
