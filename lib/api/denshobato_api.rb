require 'grape'

class DenshobatoApi < Grape::API
  mount MessageApi
end
