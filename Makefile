%:
	@:

test_alias=test t
t:
	make test
test:
	docker-compose run --rm app bundle exec rspec $(filter-out $(test_alias), $(MAKECMDGOALS))

c:
	make console
console:
	docker-compose run --rm app bundle exec rails c

ac:
	make assets_percompile
assets_percompile:
	docker-compose run --rm app bundle exec rake assets:precompile

generate_stimulus=generate_stimulus gs
gs:
	make generate_stimulus $(filter-out $(generate_stimulus), $(MAKECMDGOALS))
generate_stimulus:
	docker-compose run --rm app bundle exec rails generate stimulus $(filter-out $(generate_stimulus), $(MAKECMDGOALS))

su:
	make stimulus_update
stimulus_update:
	docker-compose run --rm app bundle exec rails stimulus:manifest:update

b:
	make bash
bash:
	docker-compose run --rm app bash

a:
	make attach
attach:
	docker attach bitcoin_wallet_web-app-1

r:
	make restart
restart:
	docker restart bitcoin_wallet_web-app-1

s:
	make start
start:
	docker-compose up -d
