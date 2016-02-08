module Denshobato
  class Engine < Rails::Engine
    initializer 'denshobato initialize' do
      ActiveSupport.on_load(:active_record) do
        p 'Added to your app!'
      end
    end
  end
end
