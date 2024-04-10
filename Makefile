# local install
prepare: install_gems make_env_file







install_gems:
	bundle install

make_env_file:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
	fi