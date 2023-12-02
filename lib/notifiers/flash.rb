# frozen_string_literal: true

module Notifiers
  class Flash
    def call(user_id:, message:)
      Turbo::StreamsChannel.broadcast_update_to(
        ['notifications', user_id],
        partial: 'layouts/notifications',
        target: 'notifications_container',
        locals: {
          notifications: {
            notice: message
          }
        }
      )
    end
  end
end
