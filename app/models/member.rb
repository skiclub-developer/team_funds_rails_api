class Member < ApplicationRecord
  validates_presence_of :name

  has_many :member_penalties
  has_many :member_beer_payments
  has_many :member_payments

  enum member_type: [:coach, :player, :assistant]
end