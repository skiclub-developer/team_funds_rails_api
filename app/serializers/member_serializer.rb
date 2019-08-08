class MemberSerializer < ActiveModel::Serializer
  attributes :id, :name, :current_money_penalties, :current_beer_penalties, :created_at
end
