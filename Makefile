#!make

## Prereq
#
# System Tools: make, inotify-tools, zip, jq, grep
# Node & Yarn
#

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

MAKEFLAGS += --silent

THEME_PATH := $(shell pwd)
THEME_NAME := $(shell node -pe 'require("./package.json").name')
THEME_VERSION := $(shell node -pe 'require("./package.json").version')

.PHONY: all clean release test watch zip build help
.DEFAULT: all

all: node_modules build help ## (default) checks for upgrades and builds all static files

build: partials/icons assets/img assets/js/bundle.js assets/css/style.css ## builds all the static assets

zip: ${THEME_NAME}.zip ## convert the package tgz to ${THEME_NAME}.zip

release: ## bump the version and publish to NPM
	@yarn version --minor
	@yarn publish
	@git push --follow-tags
	@git fetch

help: ## displays this help
	@cat COPYRIGHT
	@echo
	@echo "Usage: make [TARGET [TARGET]]"
	@echo
	@echo "Targets:"
	@grep --no-filename -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

watch: all ## watches for changes using inotifywait OR sleeps for 3 seconds then triggers a build
	@while true; do \
		inotifywait -qr -e modify -e move -e create -e delete src *.hbs */*.hbs || sleep 3; \
    	make build; \
	done

test: assets ## runs gscan test
	@yarn gscan . --fatal --verbose

clean: ## clean up built assets and reset Live Theme variables
	@rm -rf assets || echo "Skipping"

#- Real Targets

assets/css/_live.scss: $(wildcard .env*)
	mkdir -p assets/css
ifdef GHOST_ADMIN_API_KEY
	@echo '\044primary: $(shell curl \
		-H "Authorization: Ghost ${GHOST_ADMIN_API_KEY}" \
		-H "Accept-Version: v5.1" \
		-s ${GHOST_API_URL}/ghost/api/admin/site/ | jq -r ".site.accent_color")' > assets/css/_live.scss
else
	@touch assets/css/_live.scss
endif

assets/css/style.css: assets/css/_live.scss src/scss/style.scss $(wildcard src/scss/*.scss) $(wildcard src/scss/**/*.scss)
	@yarn sass --load-path=./node_modules/ src/scss/style.scss:assets/css/style.css

assets/js/bundle.js: src/es/main.js
	@yarn browserify src/es/main.js -o assets/js/bundle.js

assets/img: $(wildcard src/img/*)
	@yarn imagemin src/img/* --out-dir=assets/img --plugin=pngquant --plugin=mozjpeg --plugin=gifsicle
	@yarn imagemin src/img/* --out-dir=assets/img --plugin=webp

partials/icons: $(wildcard *.hbs */*.hbs node_modules/bootstrap-icons/icons/*.svg)
	@(for FILE in $(shell grep --exclude-dir="partials/icons" -h --only-matching -E "icons\/.+\.svg" *.hbs **/*.hbs); do \
		cp node_modules/bootstrap-icons/$$FILE partials/$$FILE.hbs; \
	done)

${THEME_NAME}.zip: ${THEME_NAME}-v${THEME_VERSION}.tgz
	tar xzf ${THEME_NAME}-v${THEME_VERSION}.tgz &&\
	(cd package && zip -r ../${THEME_NAME}.zip *) &&\
	rm -rf package

${THEME_NAME}-v${THEME_VERSION}.tgz: yarn.lock package.json
	@yarn pack

yarn.lock: package.json
	@yarn upgrade
	@touch yarn.lock

node_modules: yarn.lock
	@yarn
	@touch yarn.lock node_modules