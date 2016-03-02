module Denshobato
  module Generators
    class InstallChatGenerator < Rails::Generators::Base
      source_root File.dirname(__FILE__)
      desc 'Install Chat Panel'

      def copy_conversations
        puts 'Copying assets'

        copy_file './assets/javascripts/denshobato.js', 'vendor/assets/javascripts/denshobato.js'
        copy_file './assets/stylesheets/denshobato.scss', 'vendor/assets/stylesheets/denshobato.scss'
      end

      def done
        puts "    =====================================================
                1. Copy this line to your config/initializers/assets.rb
                  Rails.application.config.assets.precompile += %w( denshobato.js )

                2. Add '@import 'denshobato'; to your application.scss'

                3. In layouts/application.erb include javascript file to the bottom
                  Like this:

                  <body>
                    <div class='container'>
                      <%= render 'layouts/header' %>
                      <%= yield %>
                    </div>

                    <%= javascript_include_tag 'denshobato' %>
                  </body>

                4. Mount API route in your routes.rb
                   mount Denshobato::DenshobatoApi => '/'

                5. Add this helper with arguments to the page with your conversation
                   e.g  # => conversation/32

                   = render_denshobato_messages(@conversation, current_user)

                   When @conversation = Denshobato::Conversation.find(params[:id])
                   and current_user is your signed_in user, e.g Devise current_user etc.

                That's all!
    =====================================================
          "
      end
    end
  end
end
