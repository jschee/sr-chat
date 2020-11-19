import Rails from '@rails/ujs'
import ApplicationController from './application_controller'
import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'

export default class extends ApplicationController {

  connect() {
    StimulusReflex.register(this);

    document.addEventListener('cable-ready:after-insert-adjacent-html', e => {
      var messages = document.querySelectorAll(".message-container");
      var lastMessage = messages[messages.length - 1];
      setTimeout(lastMessage.scrollIntoView(), 600);
    });
  }

  send_message(event) {
    Rails.stopEverything(event)
    let textArea = document.getElementById('text-area-content');
    this.stimulate('chat#send_message', event.target, textArea.value);
    textArea.value = "";
  }

}
