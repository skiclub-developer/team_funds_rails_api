class MemberPenalty < ApplicationRecord
  validates_presence_of :penalty, :member, :amount, :changed_by

  belongs_to :member
  belongs_to :penalty
end