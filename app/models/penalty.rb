class Penalty < ApplicationRecord
  validates_presence_of :penalty_name, :penalty_cost, :case_of_beer_cost
end
