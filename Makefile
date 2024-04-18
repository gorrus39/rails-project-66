# local install for development mode
install: install_gems make_env_file make_dev_cache_file prepare_db prepare_assets

for_render: install_gems prepare_db_for_render prepare_assets

make_dev_cache_file:
	rails dev:cache

prepare_assets:
	bin/rails assets:precompile

prepare_db:
	bin/rails db:create db:migrate

prepare_db_for_render:
	bin/rails db:migrate RAILS_ENV=production

install_gems:
	bundle install

make_env_file:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
	fi