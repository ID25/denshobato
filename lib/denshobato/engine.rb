module Denshobato
  class Engine < Rails::Engine
    initializer 'initialize Denshobato' do |_app|
      ActiveSupport.on_load(:active_record) do
        include Denshobato
      end
    end
  end
end
