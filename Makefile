# DOCKER INSTALL
UPDATE_GIT = sudo apt update
INSTALL_DOCKER_PREREQUISITES = sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
DOCKER_GPG_KEY = curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
DOCKER_REPO = echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
DOCKER_CACHE = apt-cache policy docker-ce
DOCKER_INSTALL = sudo apt update && sudo apt install docker-ce -y
DOCKER_AS_USER = sudo usermod -aG docker ${USER} && su - ${USER}
DOCKER_COMPOSE_DOWNLOAD = mkdir -p ~/.docker/cli-plugins/ && curl -SL https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
DOCKER_COMPOSE_PERMISSIONS = chmod +x ~/.docker/cli-plugins/docker-compose

# REQUIREMENTS
APT_PACKAGES = sudo apt install -y npm
NVM = curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
NODE = nvm install 18 && nvm use 18 && npm install -g yarn
TYPESCRIPT = npm install -g typescript ts-node nodemon

# DOCKER
START_DOCKER = docker compose up -d
START_DOCKER_DEV = docker compose -f docker-compose-dev.yml up -d
START_DOCKER_CERT = docker compose -f docker-compose-cert.yml up -d
STOP_DOCKER = docker compose stop
DOCKER_LOGS = docker compose logs -t -f --tail 10
DOCKER_CLEAR = docker compose rm -fs

# GIT
GIT_UPDATE = git config --global submodule.recurse true && git pull --recurse-submodules

install:
	@$(UPDATE_GIT)
	@$(INSTALL_DOCKER_PREREQUISITES)
	@$(DOCKER_GPG_KEY)
	@$(DOCKER_REPO)
	@$(UPDATE_GIT)
	@$(DOCKER_CACHE)
	@$(DOCKER_INSTALL)
	@$(DOCKER_AS_USER)
	@$(DOCKER_COMPOSE_DOWNLOAD)
	@$(DOCKER_COMPOSE_PERMISSIONS)
	@$(APT_PACKAGES)
	@$(NVM)
	@$(NODE)
	@$(TYPESCRIPT)
start:
	$(START_DOCKER)
dev:
	$(START_DOCKER_DEV)
cert:
	$(START_DOCKER_CERT)
stop:
	@$(STOP_DOCKER)
restart:
	@$(STOP_DOCKER)
	@$(START_DOCKER)
log:
	@$(DOCKER_LOGS)
rm:
	@$(DOCKER_CLEAR)
update:
	@$(GIT_UPDATE)
	@$(INSTALL_NPM)
	@$(STOP_DOCKER)
	@$(START_DOCKER)
getcert:
	docker compose run --rm dcardenascom-certbot certonly --webroot --webroot-path /var/www/certbot/ -d dcardenas.com
renew:
	docker compose run --rm dcardenascom-certbot renew
