class MemberPayment < ApplicationRecord
  validates_presence_of :member, :amount, :changed_by

  belongs_to :member
end