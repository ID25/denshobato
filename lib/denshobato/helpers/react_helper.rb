module Denshobato
  module ReactHelper
    def render_denshobato_messages(room)
      content_tag(:div, '', id: 'denshobato-message-panel', data: { room: room.id })
    end
  end
end
