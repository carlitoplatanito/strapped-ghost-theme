
window.jQuery = $ = require('jquery');

const { Collapse } = require('bootstrap');
const AOS = require('aos');

/**
 * Initiate [AOS](https://github.com/michalsnik/aos) for
 * Animation on Scroll functionality.
 * 
 * Note: If disabled, make sure to disable the scss import as well.
 */
// AOS.init();
const bsCollapse = new Collapse('.collapse', {
  toggle: false
});
