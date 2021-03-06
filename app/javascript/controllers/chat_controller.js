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

  toAnchor () {
    var jumpToAnchor = document.getElementById('auto-scroll-anchor');
    jumpToAnchor.scrollIntoView();
    document.removeEventListener('cable-ready:after-insert-adjacent-html', this.toAnchor);
  }

  getMessages(event) {
    Rails.stopEverything(event);
    let chatWindow = document.getElementById('chat-window');
    let chatRoomId = event.target.dataset.id;
    let userSlug = event.target.dataset.user;
    if (chatWindow.scrollTop === 0 ) {
      let messagesCount = this.messageContainerCount;
      this.lastScrollHeight = chatWindow.scrollHeight;
      this.fetchMessages(chatRoomId, userSlug, messagesCount);
    }
  }

  fetchMessages(chatRoomId, userSlug, messagesCount) {
    Rails.stopEverything(event);
    let chatWindow = document.getElementById('chat-window');
    this.stimulate('chat#fetch_messages', event.target, chatRoomId, userSlug, messagesCount);
    this.messageContainerCount = document.querySelectorAll(".message-container").length;
    let scrollHeight = this.lastScrollHeight;
    var scrollTop = function(e){
      let chatWindow = document.getElementById('chat-window');
      chatWindow.scrollTop += (chatWindow.scrollHeight - scrollHeight)
      document.removeEventListener('cable-ready:after-insert-adjacent-html', scrollTop)
    }
    document.addEventListener('cable-ready:after-insert-adjacent-html', scrollTop);
  }

  sendMessage = (event) => {
    Rails.stopEverything(event);
    let textArea = document.getElementById('text-area-content');
    let userSlug = document.getElementById('chat-window').dataset.slug;
    if (textArea.value.length > 0) {
      this.messageContainerCount ++; // increment counter state
      this.stimulate('chat#send_message', event.target, textArea.value, userSlug);
      textArea.value = "";
      document.addEventListener('cable-ready:after-insert-adjacent-html', this.toAnchor)
    } else {
      alert('You need to type something!')
    }
  }

  sendAttached() {
    Rails.stopEverything(event);
    var submit = document.getElementById('attach-send');
    var file_input = document.getElementById('attach-input');
    submit.click();
    file_input.value = ''
    document.addEventListener('cable-ready:after-insert-adjacent-html', this.toAnchor);
  }

  showOptions (event) {
    Rails.stopEverything(event);
    var options = event.target.querySelector('.message-options');
    options.classList.remove('hidden');
  }

  hideOptions (event) {
    Rails.stopEverything(event);
    var options = event.target.querySelector('.message-options');
    options.classList.add('hidden');
  }

  revealSearch (event) {
    Rails.stopEverything(event);
    var search = document.getElementById('search-chats');
    search.classList.remove('hidden');
    var input = document.getElementById('chat-search-input')
    input.focus()
  }

  hideSearch (event) {
    Rails.stopEverything(event);
    var search = document.getElementById('search-chats');
    var input = document.getElementById('chat-search-input')
    search.classList.add('hidden');
    input.value = '';
  }

  searchConversations (event) {
    Rails.stopEverything(event);
    let input = document.getElementById("chat-search-input");
    let filter = input.value.toUpperCase();
    let list = document.getElementById("chat-list");
    let chatroom = list.getElementsByTagName("li");
    for ( let i = 0; i < chatroom.length; i++ ) {
      let first = chatroom[i].getElementsByClassName("users-username")[0];
      let txtValue = first.textContent || first.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        chatroom[i].style.display = ""
      } else {
        chatroom[i].style.display = "none"
      }
    }

  }

  beforeReflex () {
    this.benchmark = performance.now()
  }

  afterReflex(element, reflex) {
     console.log(reflex, `${(performance.now() - this.benchmark).toFixed(0)}ms`)
  }


}
