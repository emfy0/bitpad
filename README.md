# [Bitpad](https://bitpad.ru)

Bitpad is non castodial, service for managing bitcoin wallet

Wallet's private keys, are stored in database with encryption.
Users token is a key to decrypt it.
Service dont store tokens, so it hasn't access to users private keys.
Once user logged in, users token is stored in encrypted cookie, so he doesn't need to enter it again.

# Local development

## Requirements

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Setup
```bash
$ git clone
$ cd bitpad
$ docker-compose up -d
```

go to [localhost:3000](http://localhost:3000)

for available commands see `Makefile`

# Production deployment

## Requirements

- [Docker](https://www.docker.com/)
- [Docker Swarm](https://docs.docker.com/engine/swarm/)

## Setup
```bash
$ git clone
$ make deploy
```

