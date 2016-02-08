module Denshobato
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.dirname(__FILE__)
      desc 'Add the migrations'

      def copy_conversations
        copy_file './migrations/create_conversations.rb', "db/migrate/#{time}_create_denshobato_conversations.rb"
      end

      def copy_messages
        sleep 1
        copy_file './migrations/create_messages.rb', "db/migrate/#{time}_create_denshobato_messagess.rb"
      end

      def done
        puts 'Denshobato Installed'
      end

      private

      def time
        DateTime.now.to_s(:number)
      end
    end
  end
end
