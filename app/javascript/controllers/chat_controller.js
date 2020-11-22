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
      let lastScrollHeight = chatWindow.scrollHeight;
      this.fetchMessages(slug, messagesCount, lastScrollHeight);
    }
  }

  fetchMessages(slug, messagesCount, lastScrollHeight) {
    Rails.stopEverything(event);
    console.log('fetching...')
    let chatWindow = document.getElementById('chat-window');
    Rails.ajax({
      type: "GET",
      url: `/chat/${slug}/${messagesCount}`,
      dataType: 'json',
      success: (data) => {
        console.log(data);
        this.timelineTarget.insertAdjacentHTML('afterbegin', data.entries)
        chatWindow.scrollTop += (chatWindow.scrollHeight - lastScrollHeight)
      }
    })

    this.messageContainerCount ++
    console.log(this.messageContainerCount)
  }

  sendAttached() {
    var submit = document.getElementById('attach-send');
    var file_input = document.getElementById('attach-input');
    submit.click();
    file_input.value = ''

  }

  showOptions (event) {
    var options = event.target.querySelector('.message-options');
    options.classList.remove('hidden');
  }

  hideOptions (event) {
    var options = event.target.querySelector('.message-options');
    options.classList.add('hidden');
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
