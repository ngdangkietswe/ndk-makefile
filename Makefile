include .env

# Variables
PROJECTS := ${PROJECTS}
MIGRATIONS := ${MIGRATIONS}
PROTO_REPO := ${PROTO_REPO}
GOPRIVATE := export GOPRIVATE=${GO_PRIVATE}

# Git pull with optional checkout
pull-%:
	cd lms-$* && git pull origin dev

co-pull-%:
	cd lms-$* && git checkout dev && git pull origin dev

# Generate Java builds
gen-%:
	cd lms-$* && mvn -T 1C clean install -Dmaven.test.skip -DskipTests

# Generate Go builds
gen-auth gen-gateway: %:
	cd lms-$* && $(GOPRIVATE) && go get $(PROTO_REPO) && go mod tidy && go mod vendor

# Docker commands
docker-run:
	cd docker && make run

docker-stop:
	cd docker && make down

# Migrations
migrate-%:
	cd lms-migration && make migrate-$*-local

# Convenient Targets
.PHONY: all-pull all-co-pull all-gen all-migrate

all-pull: $(addprefix pull-, $(PROJECTS))
all-co-pull: $(addprefix co-pull-, $(PROJECTS))
all-gen: $(addprefix gen-, $(PROJECTS))
all-migrate: $(addprefix migrate-, $(MIGRATIONS))