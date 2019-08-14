class MemberPenaltySerializer < ActiveModel::Serializer
  attributes :amount, :created_at

  has_one :penalty
end
