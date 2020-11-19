class DeliverMessageChannel < ApplicationCable::Channel
  def subscribed
    stream_from "DeliverMessageChannel"
  end
end
