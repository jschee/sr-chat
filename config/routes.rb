
Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'marketings#home'

  get '/chat/:chat_slug' => "marketings#chat", as: "chat"
  get '/chat/:chat_slug/:message_count' => "marketings#get_old_messages", as: "get_old_messages"
  get '/start-convo/:user_slug' => "marketings#start_conversation", as: "start_conversation"
  post '/chat/:user_slug/create' => "marketings#create_chat", as: "create_chat_room"
end

