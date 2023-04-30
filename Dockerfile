FROM ruby:3.1.2-slim as rails

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

LABEL org.opencontainers.image.source=https://github.com/emfy0/bitpad

FROM nginx as nginx

RUN rm /etc/nginx/conf.d/default.conf

COPY .deploy/nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=rails /code/public/ /usr/share/nginx/html/

LABEL org.opencontainers.image.source=https://github.com/emfy0/bitpad
