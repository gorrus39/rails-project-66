# local install
install: install_gems make_env_file prepare_db prepare_assets



prepare_assets:
	bin/rails assets:precompile

prepare_db:
	bin/rails db:create db:migrate

install_gems:
	bundle install

make_env_file:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
	fi