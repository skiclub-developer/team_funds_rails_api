module API
  module V1
    class Punishments < Grape::API
      include API::V1::Defaults

      resource :penalties do
        desc "Return all punishments"
        get do
          Penalty.all
        end
      end
    end
  end
end
