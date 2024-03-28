import "jquery"
window.jQuery = $;
window.$ = $;

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@nathanvda/cocoon"
import "./utils"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
