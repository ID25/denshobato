module Denshobato
  module ReactHelper
    def render_denshobato_messages(room, user)
      content_tag(:div, '', id: 'denshobato-message-panel', data: { room: room.id, current_user_id: user.id, current_user_class: user.class.name })
    end
  end
end
