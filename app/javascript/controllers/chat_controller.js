import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'
import ApplicationController from './application_controller'
import Rails from '@rails/ujs'

export default class extends ApplicationController {

  static targets = ['timeline']

  initialize(){
    this.messageContainerCount = document.querySelectorAll(".message-container").length;
  }

  connect() {
    console.log(this.messageContainerCount);
    StimulusReflex.register(this);
    document.addEventListener('cable-ready:after-insert-adjacent-html', e => {
      let messages = document.querySelectorAll(".message-container");
      let lastMessage = messages[messages.length - 1];
      setTimeout(lastMessage.scrollIntoView(), 600);
    });
  }

  getMessages(event) {
    Rails.stopEverything(event);
    let chatWindow = document.getElementById('chat-window');
    if (chatWindow.scrollTop === 0 ) {
      let slug = event.target.dataset.slug;
      let messagesCount = this.messageContainerCount;
      this.fetchMessages(slug, messagesCount);
    }
  }

  fetchMessages(slug, messagesCount) {
    Rails.stopEverything(event);
    console.log('fetching...')
    let chatWindow = document.getElementById('chat-window');
    let lastScrollHeight = chatWindow.scrollHeight;
    Rails.ajax({
      type: "GET",
      url: `/chat/${slug}/${messagesCount}`,
      dataType: 'json',
      success: (data) => {
        console.log(data);
        this.timelineTarget.insertAdjacentHTML('afterbegin', data.entries)
        chatWindow.scrollTop += (chatWindow.scrollHeight-lastScrollHeight)
      }
    })

    this.messageContainerCount ++
    console.log(this.messageContainerCount)
  }

  send_message = (event) => {
    Rails.stopEverything(event);
    let textArea = document.getElementById('text-area-content');
    if (textArea.value.length > 0) {
      this.messageContainerCount ++; // increment counter state
      this.stimulate('chat#send_message', event.target, textArea.value);
      textArea.value = "";
    } else {
      alert('You need to type something!')
    }
  }

}
