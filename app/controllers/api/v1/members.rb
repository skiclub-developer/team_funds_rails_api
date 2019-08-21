module API
  module V1
    class Members < Grape::API
      include API::V1::Defaults

      resource :members do
        desc "Return all members"
        params do
          optional :members, type: String
          optional :member, type: String
        end
        get do
          members = params["members"]
          member_param = params["member"]
          if members.present?
            members_array = members.split(",")
            members_not_found = []
            found_members = Member.where(name: members_array)
            members_array.each do |member|
              found = false
              found_members.each do |found_member|
                if found_member.name == member
                  found = true
                end
              end
              unless found
                members_not_found.push member
              end
            end

            {found_members: found_members, members_not_found: members_not_found}
          elsif member_param.present?
            member = Member.find_by(name: member_param)
            if member.present?
              {money_payments: MemberPayment.where(member: member), beer_payments: MemberBeerPayment.where(member: member),
               member_penalties: MemberPenalty.where(member: member)}
            else
              {error: "Spieler #{member_param} konnte nicht gefunden werden"}
            end
          else
            Member.all
          end
        end

        desc "Update all members"
        params do
          optional :members, type: Array do
            requires :name, type: String
            requires :amount, type: Integer
          end
          optional :payment_type, type: String
        end
        patch do
          members_param = params["members"]
          if members_param.present?
            payment_type = params["payment_type"]
            if payment_type.present?
              updated_members = []
              members_not_found = []
              members_without_amount = []
              members_param.each do |member_param|
                name = member_param["name"]
                amount = member_param["amount"]
                member = Member.find_by(name: name)
                if member.present?
                  if amount.present?
                    if payment_type == "beer"
                      member.current_beer_penalties = member.current_beer_penalties + amount
                      member.save

                      updated_members.push({name: name, amount: amount})
                    else
                      member.current_money_penalties = member.current_money_penalties + amount
                      member.save

                      updated_members.push({name: name, amount: amount})
                    end
                  else
                    members_without_amount.push name
                  end
                else
                  members_not_found.push name
                end
              end
              {updated_members: updated_members, members_not_found: members_not_found,
               members_without_amount: members_without_amount}
            else
              {error: "Kein payment_type mit angegeben"}
            end
          else
            penalty = Penalty.find_by(penalty_name: 'pflichtspielverloren')
            if penalty.present?
              Member.where(member_type: :player).each do |member|
                member.current_money_penalties = member.current_money_penalties + penalty.penalty_cost
                member.save
              end
            else
              {error: 'Strafe "pflichtspielverloren" wurde noch nicht angelegt'}
            end
          end
        end

        desc "Pay penalty for member"
        params do
          requires :members, type: Array do
            requires :name, type: String
            requires :amount, type: String
          end
          requires :telegram_user, type: String
          requires :payment_type, type: String
        end
        post "/pay" do
          members_param = params[:members]
          telegram_user = params[:telegram_user]
          payment_type = params[:payment_type]

          members_not_found = []
          updated_members = []

          members_param.each do |member|
            member_name = member["name"]
            amount = member["amount"].to_i
            current_member = Member.find_by(name: member_name)
            if current_member.present?
              if payment_type == "beer"
                current_member.current_beer_penalties = current_member.current_beer_penalties - amount
                current_member.save

                MemberBeerPayment.new(member: current_member, amount: amount, changed_by: telegram_user).save
              else
                current_member.current_money_penalties = current_member.current_money_penalties - amount
                current_member.save

                MemberPayment.new(member: current_member, amount: amount, changed_by: telegram_user).save
              end

              updated_members.push({name: current_member.name, amount: amount})
            else
              members_not_found.push(member_name)
            end
          end
          {updated_members: updated_members, members_not_found: members_not_found}
        end

        desc "Add punishment to members"
        params do
          requires :members, type: Array do
            requires :name, type: String
            requires :amount, type: String
          end
          requires :penalty_name, type: String
          requires :telegram_user, type: String
        end
        post "/punish" do
          members_param = params[:members]
          penalty_name = params[:penalty_name]
          telegram_user = params[:telegram_user]
          current_penalty = Penalty.find_by(penalty_name: penalty_name.downcase)

          members_not_found = []
          updated_members = []

          if current_penalty.present?
            members_param.each do |member|
              member_name = member["name"]
              amount = member["amount"].to_i
              current_member = Member.find_by(name: member_name)
              if current_member.present?
                #calculate current cost and beer cost
                cost = current_penalty.penalty_cost * amount
                beer_cost = current_penalty.case_of_beer_cost * amount

                #update penalties for current member
                current_member.current_money_penalties = current_member.current_money_penalties + cost
                current_member.current_beer_penalties = current_member.current_beer_penalties + beer_cost
                current_member.save!

                #create member penalty
                MemberPenalty.new(member: current_member, penalty: current_penalty, amount: amount,
                                  changed_by: telegram_user).save

                #add member to updated members
                updated_members.push({name: current_member.name, cost: cost})
              else
                members_not_found.push(member_name)
              end
            end

            {updated_members: updated_members, members_not_found: members_not_found}
          else
            {error: "Die Strafe #{penalty_name} konnte nicht gefunden werden"}
          end
        end

        desc "Return a member"
        params do
          requires :id, type: String, desc: "ID of the member"
        end
        get ":id", root: "member" do
          Member.where(id: permitted_params[:id]).first!
        end
      end
    end
  end
end
