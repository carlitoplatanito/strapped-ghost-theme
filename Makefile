#!make

## Prereq
# - make, inotify-tools, zip, jq
# - Node & Yarn

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

MAKEFLAGS += --silent

THEME_NAME := $(shell node -pe 'require("./package.json").name')
THEME_VERSION := $(shell node -pe 'require("./package.json").version')

.PHONY: all clean release test watch zip icons
.DEFAULT: assets

assets: assets/img assets/js assets/css

assets/css: assets/css/style.css ## Compile SASS

src/scss/_ghost.scss: ## Generates scss file with Live Theme Integration
ifdef GHOST_ADMIN_API_KEY
	@echo '\044primary: $(shell curl \
		-H "Authorization: Ghost ${GHOST_ADMIN_API_KEY}" \
		-H "Accept-Version: v5.1" \
		-s ${GHOST_API_URL}/ghost/api/admin/site/ | jq -r ".site.accent_color")' > src/scss/_ghost.scss
else
	@touch src/scss/_ghost.scss
endif

assets/css/style.css: src/scss/_ghost.scss src/scss/style.scss $(wildcard src/scss/*.scss) $(wildcard src/scss/**/*.scss)
	@yarn sass --load-path=./node_modules/ src/scss/style.scss:assets/css/style.css

assets/js: assets/js/bundle.js ## Browserify src/es/main.js -> assets/js/bundle.js
assets/js/bundle.js: src/es/main.js
	@yarn browserify src/es/main.js -o assets/js/bundle.js

assets/img: $(wildcard src/img/*) ## Compress images and create compressed webm copy
	@yarn imagemin src/img/* --out-dir=assets/img --plugin=pngquant --plugin=mozjpeg --plugin=gifsicle
	@yarn imagemin src/img/* --out-dir=assets/img --plugin=webp

icons:
	@(cd node_modules/bootstrap-icons/icons/; \
	for FILE in *.svg; do \
		cp $$FILE partials/icons/$$FILE.hbs; \
	done)

zip: ${THEME_NAME}.zip ## convert the package tgz to theme.zip (runs automatically after `yarn pack`)
${THEME_NAME}.zip: ${THEME_NAME}-v${THEME_VERSION}.tgz
	tar xzf ${THEME_NAME}-v${THEME_VERSION}.tgz &&\
	(cd package && zip -r ../${THEME_NAME}.zip *) &&\
	rm -rf package

release:
	@yarn version --minor
	@git push --follow-tags
	@git fetch

all: assets

watch: all ## watches src directory using inotifywait OR sleeps for 3 seconds
	@while true; do \
		inotifywait -qr -e modify -e create -e delete -e move src || sleep 3; \
    	make assets; \
	done

test: assets
	@yarn gscan . --fatal --verbose

clean:
	@rm -rf assets src/scss/_ghost.scss || echo "Skipping"