import { Controller } from 'stimulus'
import StimulusReflex from 'stimulus_reflex'
import ApplicationController from './application_controller'
import Rails from '@rails/ujs'

export default class extends ApplicationController {

  static targets = ['timeline']

  initialize(){
    this.messageContainerCount = document.querySelectorAll(".message-container").length;
    this.lastScrollHeight = 0
  }

  connect() {
    console.log('msg containers count: ', this.messageContainerCount);
    StimulusReflex.register(this);
  }

  getMessages(event) {
    Rails.stopEverything(event);
    let chatWindow = document.getElementById('chat-window');
    let chatRoomId = event.target.dataset.id;
    let userSlug = event.target.dataset.user;
    if (chatWindow.scrollTop === 0 ) {
      let messagesCount = this.messageContainerCount;
      this.lastScrollHeight += chatWindow.scrollHeight;
      console.log(this.lastScrollHeight)
      this.fetchMessages(chatRoomId, userSlug, messagesCount);


    }
  }

  fetchMessages(chatRoomId, userSlug, messagesCount) {
    Rails.stopEverything(event);
    console.log('fetching messages...')
    let chatWindow = document.getElementById('chat-window');
    this.stimulate('chat#fetch_messages', event.target, chatRoomId, userSlug, messagesCount);
    this.messageContainerCount = document.querySelectorAll(".message-container").length;

    document.addEventListener('cable-ready:after-insert-adjacent-html', e => {
      console.log('inside get messages eventlistener')
      chatWindow.scrollTop += (chatWindow.scrollHeight - this.lastScrollHeight)
      console.log(this.lastScrollHeight)
    });


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
    let userSlug = document.getElementById('chat-window').dataset.slug;
    if (textArea.value.length > 0) {
      this.messageContainerCount ++; // increment counter state
      this.stimulate('chat#send_message', event.target, textArea.value, userSlug);
      textArea.value = "";
      document.addEventListener('cable-ready:after-insert-adjacent-html', e => {
        console.log('listening to cableready in send message')
        var element_to_scroll_to = document.getElementById('auto-scroll-anchor');
        element_to_scroll_to.scrollIntoView();
      });
    } else {
      alert('You need to type something!')
    }
  }

  restScreenAfterMessage = (event) => {

  }

}
