# Strapped
## YABS Theme for [Ghost Platform](https://ghost.org)

**Strapped** is **Yet Another Bootstrap Starter (YABS)** Theme but for [Ghost Platform](https://ghost.org).

## Features

⛏ Faster and more robust building with good old fasioned [Make](https://www.gnu.org/software/make/manual/make.html)

✨ CSS styled with [SASS](https://sass-lang.com/) directly

☕ Javascript compiled with [browserify](https://browserify.org/)

### [Bootstrap 5.2](https://getbootstrap.com/docs/5.2/getting-started/introduction/)

Built around Bootstrap 5.2 with all it's goodness available to be turned on right in the `src/scss/_global.scss` file.

### [Bootstrap Icons](https://icons.getbootstrap.com/)

Simply import an an icon into to your theme template (ie `{{>icons/airplane.svg}}`) and the file will be copied from `node_modules/bootstrap-icons` into `partials/icons` with the `.hbs` extension.

### Live Theme Variables

Automatically load your `@site/accent_color` into sass variables. Set as `$primary` for your theme to match.

**Setup Live Theme Variables**

1. Create a new **Integration** in the Ghost Admin.
    
    > Go to **Settings** > **Integrations** click **Add custom integration**

2. Create a `.env` file in the base of your theme directory and copy the following variables into it from your new Integration. (In auto-deployment you would set these variables in your Github Project's global variables).

    ```.env
    GHOST_API_URL=[API URL]
    GHOST_CONTENT_API_KEY='[Content API key]'
    GHOST_ADMIN_API_KEY='[Admin API key]'
    ```

3. Run `make build`, `assets/css/_live.scss` should be generated with your Ghost instances `@site.accent_color`.

## Commands

[Make](https://www.gnu.org/software/make/) is used for all commands. Run `make help` for a list of all make targets.

**Usage:**

`make [TARGET [TARGET]]`

**Targets:**

`all` - (default) checks for upgrades and builds all static files\
`build` - builds all the static assets\
`clean` - clean up built assets and reset Live Theme variables\
`help` - displays this help\
`release` - bump the version and publish to NPM\
`test` - runs gscan test\
`watch` - watches for changes using inotifywait OR sleeps for 3 seconds then triggers a build\
`zip` - convert the package tgz to ${THEME_NAME}.zip

