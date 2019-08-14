module API
  module V1
    class MemberPenalties < Grape::API
      include API::V1::Defaults

      resource :member_penalties do
        desc "Return member penalty for a member"
        params do
          optional :name, type: String, desc: "Name of member"
        end
        get do
          name_param = params["name"]
          if name_param.present?
            member = Member.find_by(name: name_param)
            if member.present?
              MemberPenalty.where(member: member)
            else
              {error: "Spieler mit dem Namen #{name_param} wurde nicht gefunden"}
            end
          end
        end

        desc "Create member penalty"
        params do
          requires :telegram_user, type: String
        end
        post do
          telegram_user = params["telegram_user"]
          penalty = Penalty.find_by(penalty_name: 'pflichtspielverloren')
          if penalty.present?
            Member.where(member_type: :player).each do |member|
              MemberPenalty.new(member: member, penalty: penalty, amount: 1, changed_by: telegram_user).save
            end
          else
            {error: 'Strafe "pflichtspielverloren" wurde noch nicht angelegt'}
          end
        end
      end
    end
  end
end
