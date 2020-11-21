require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels")
require('css/application.scss');
require('typeface-inter');

require.context('../images', true);

import Rails from '@rails/ujs'
window.Rails = Rails
import "controllers"
