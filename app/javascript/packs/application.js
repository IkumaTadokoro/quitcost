// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
import 'stylesheets/application.css'
import 'src/main.js'
import 'src/insurances.js'
import 'src/pensions.js'
import 'src/local-gov-select.js'
import { library, dom } from '@fortawesome/fontawesome-svg-core'
import {
  faInfoCircle,
  faRobot,
  faEdit,
  faTrash
} from '@fortawesome/free-solid-svg-icons'

library.add(faInfoCircle, faRobot, faEdit, faTrash)
dom.watch()
Rails.start()
