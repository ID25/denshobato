module Denshobato
  module ReactHelper
    def render_denshobato_messages(messages)
      content_tag(:div, '', id: 'denshobato-message-panel', data: { json: messages.to_json })
    end
  end
end
