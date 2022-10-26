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

1.Create a new **Integration** in the Ghost Admin.
> Settings > Integrations then click **Add custom integration**

2. Create a `.env` file in the base of your theme directory and copy the following variables into it from your new Integration. (In auto-deployment you would set these variables in your Github Project's global variables).

```.env
GHOST_API_URL=[API URL]
GHOST_CONTENT_API_KEY='[Content API key]'
GHOST_ADMIN_API_KEY='[Admin API key]'
```

3. Run the `make clean` make target to clear old variables followed by `make` to rebuild.

## Commands

```
make help
```